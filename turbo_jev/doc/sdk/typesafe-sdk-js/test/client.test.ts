import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import {
  APIConnectionError,
  APIUserAbortError,
  type Asset,
  box,
  choice,
  ENV,
  Image,
  image,
  noul,
  type Questions,
  score,
  TypeSafeClient,
  type TypeSafeClientConfig,
  TypeSafeError,
  VERSION,
  withAssets,
} from "../src";
import { DEFAULT_BASE_URL, DEFAULT_MODEL } from "../src/client";
import { MIN_COMPRESSED_BODY_BYTES } from "../src/compression";
import { DEFAULT_LOG_LEVEL, LOG_LEVELS } from "../src/logging";
import { DEFAULT_RETRY_POLICY, DEFAULT_TIMEOUT_MS } from "../src/retry";
import { describeRuntime } from "../src/runtime";
import { json, mockFetch, type RecordedRequest } from "./helpers";

/** Read the API key from an outgoing request. */
const sentApiKey = async (config: TypeSafeClientConfig = {}): Promise<string | undefined> => {
  const { fetch, requests } = mockFetch(() => json({ models: [] }));
  await new TypeSafeClient({ ...config, fetch }).models.list();
  const headers = requests[0]?.init?.headers as Record<string, string> | undefined;
  return headers?.Authorization?.replace(/^Bearer /, "");
};

const SYSTEM_ONE_RESPONSE = {
  model: "m",
  answers: { q1: { type: "noul", noul: 0.5 } },
  usage: { input_tokens: 1, output_tokens: 1 },
};

describe("TypeSafeClient configuration", () => {
  const savedEnv = { ...process.env };
  beforeEach(() => {
    for (const name of Object.values(ENV)) delete process.env[name];
  });
  afterEach(() => {
    process.env = { ...savedEnv };
  });

  it("falls back to defaults when neither config nor env is set", () => {
    const client = new TypeSafeClient({ apiKey: "k" });
    expect(client.baseURL).toBe(DEFAULT_BASE_URL);
    expect(client.defaultModel).toBe(DEFAULT_MODEL);
    expect(client.logLevel).toBe(DEFAULT_LOG_LEVEL);
    expect(client.retry).toEqual(DEFAULT_RETRY_POLICY);
    expect(client.timeout).toBe(DEFAULT_TIMEOUT_MS);
  });

  it("reads every setting from the environment", async () => {
    process.env[ENV.apiKey] = "env-key";
    process.env[ENV.baseURL] = "https://env.test";
    process.env[ENV.defaultModel] = "env-model";
    process.env[ENV.logLevel] = "debug";
    const client = new TypeSafeClient();
    await expect(sentApiKey()).resolves.toBe("env-key");
    expect(client.baseURL).toBe("https://env.test");
    expect(client.defaultModel).toBe("env-model");
    expect(client.logLevel).toBe("debug");
  });

  it("prefers config over the environment", async () => {
    process.env[ENV.apiKey] = "env-key";
    process.env[ENV.baseURL] = "https://env.test";
    process.env[ENV.defaultModel] = "env-model";
    process.env[ENV.logLevel] = "debug";
    const client = new TypeSafeClient({
      apiKey: "code-key",
      baseURL: "https://code.test",
      defaultModel: "code-model",
      logLevel: "error",
    });
    await expect(sentApiKey({ apiKey: "code-key" })).resolves.toBe("code-key");
    expect(client.baseURL).toBe("https://code.test");
    expect(client.defaultModel).toBe("code-model");
    expect(client.logLevel).toBe("error");
  });

  it("keeps the API key off the instance so logging the client cannot leak it", () => {
    const client = new TypeSafeClient({ apiKey: "super-secret" });
    expect("apiKey" in client).toBe(false);
    expect(Object.values(client)).not.toContain("super-secret");
    expect(JSON.stringify(client)).not.toContain("super-secret");
  });

  it("treats empty and whitespace-only env values as unset", () => {
    process.env[ENV.apiKey] = "k";
    process.env[ENV.baseURL] = "   ";
    process.env[ENV.defaultModel] = "";
    process.env[ENV.logLevel] = "";
    const client = new TypeSafeClient();
    expect(client.baseURL).toBe(DEFAULT_BASE_URL);
    expect(client.defaultModel).toBe(DEFAULT_MODEL);
    expect(client.logLevel).toBe(DEFAULT_LOG_LEVEL);
  });

  it("throws a TypeSafeError naming the env var when no API key is available", () => {
    expect(() => new TypeSafeClient()).toThrow(TypeSafeError);
    expect(() => new TypeSafeClient()).toThrow(ENV.apiKey);
  });

  it("strips trailing slashes from baseURL from either source", () => {
    process.env[ENV.baseURL] = "https://example.test///";
    expect(new TypeSafeClient({ apiKey: "k" }).baseURL).toBe("https://example.test");
    expect(new TypeSafeClient({ apiKey: "k", baseURL: "https://x.test/" }).baseURL).toBe(
      "https://x.test",
    );
  });

  it.each(LOG_LEVELS)("accepts log level %s", (level) => {
    expect(new TypeSafeClient({ apiKey: "k", logLevel: level }).logLevel).toBe(level);
    process.env[ENV.logLevel] = level;
    expect(new TypeSafeClient({ apiKey: "k" }).logLevel).toBe(level);
  });

  it("rejects an invalid log level and names where it came from", () => {
    process.env[ENV.logLevel] = "loud";
    expect(() => new TypeSafeClient({ apiKey: "k" })).toThrow(TypeSafeError);
    expect(() => new TypeSafeClient({ apiKey: "k" })).toThrow(`"loud" from ${ENV.logLevel}`);
    expect(() => new TypeSafeClient({ apiKey: "k" })).toThrow(LOG_LEVELS.join(", "));
    // biome-ignore lint/suspicious/noExplicitAny: deliberately bypassing the type to mimic a JS caller
    expect(() => new TypeSafeClient({ apiKey: "k", logLevel: "loud" as any })).toThrow(
      "the `logLevel` option",
    );
  });
});

describe("requests", () => {
  it("sends auth and identifying headers", async () => {
    const { fetch, requests } = mockFetch(() => json({ models: [] }));
    const client = new TypeSafeClient({ apiKey: "secret", baseURL: "https://x.test", fetch });
    await client.models.list();

    expect(requests).toHaveLength(1);
    expect(requests[0]?.url).toBe("https://x.test/v1/models");
    expect(requests[0]?.init?.method).toBe("GET");
    const headers = requests[0]?.init?.headers as Record<string, string>;
    expect(headers.Authorization).toBe("Bearer secret");
    expect(headers["User-Agent"]).toBe(`typesafe-sdk/${VERSION}`);
    expect(headers["X-TypeSafe-SDK"]).toBe(`typesafe-sdk/${VERSION}`);
    expect(headers["X-TypeSafe-Runtime"]).toBe(describeRuntime());
    expect(headers["X-TypeSafe-Runtime"]).toMatch(/^node\/\d+\.\d+\.\d+ \(\w+; \w+\)$/);
    expect(headers["Content-Type"]).toBeUndefined();
  });

  it("merges defaultHeaders and per-call headers, per-call winning, never clobbering auth", async () => {
    const { fetch, requests } = mockFetch(() => json({ models: [] }));
    const client = new TypeSafeClient({
      apiKey: "secret",
      fetch,
      defaultHeaders: { "X-Trace": "client", "X-Only-Default": "yes", Authorization: "nope" },
    });
    await client.models.list({ headers: { "X-Trace": "call", "X-Only-Call": "yes" } });
    const headers = requests[0]?.init?.headers as Record<string, string>;
    expect(headers["X-Trace"]).toBe("call");
    expect(headers["X-Only-Default"]).toBe("yes");
    expect(headers["X-Only-Call"]).toBe("yes");
    expect(headers.Authorization).toBe("Bearer secret");
  });

  it.each([{ cards: [] }, { cards: [{ name: "m", description: "d", release_date: "2026" }] }])(
    "models.list() unwraps the documented response: %j",
    async ({ cards }) => {
      const { fetch } = mockFetch(() => json({ models: cards }));
      const client = new TypeSafeClient({ apiKey: "k", fetch });
      expect(await client.models.list()).toEqual(cards);
      const { data, response } = await client.models.list().withResponse();
      expect(data).toEqual(cards);
      expect(response.status).toBe(200);
    },
  );

  it.each(
    [null, [], { models: { models: [] } }, { models: null }, { models: "bad" }, { ok: true }].map(
      (wire) => ({ wire }),
    ),
  )("models.list() fails clearly on an unrecognized shape: %j", async ({ wire }) => {
    const { fetch } = mockFetch(() => json(wire));
    await expect(new TypeSafeClient({ apiKey: "k", fetch }).models.list()).rejects.toThrow(
      "Unexpected response shape from GET /v1/models",
    );
  });

  it("preserves employee-only model fields through raw access", async () => {
    const wire = {
      models: [{ name: "m", description: "d", release_date: "2026", tags: ["internal"] }],
    };
    const { fetch } = mockFetch(() => json(wire));
    const raw = await new TypeSafeClient({ apiKey: "k", fetch }).models.list().asResponse();
    expect(raw.bodyUsed).toBe(false);
    expect(await raw.json()).toEqual(wire);
  });

  it("posts the systemOne payload with the default model", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", baseURL: "https://x.test", fetch });
    const result = await client.systemOne({ state: { a: 1 }, questions: { q1: noul("x") } });

    expect(requests[0]?.url).toBe("https://x.test/v1/systemone");
    expect(requests[0]?.init?.method).toBe("POST");
    expect(requests[0]?.body).toEqual({
      state: { a: 1 },
      model: DEFAULT_MODEL,
      questions: { q1: { type: "noul", instructions: "x", criteria: undefined } },
    });
    expect(result.answers.q1.noul).toBe(0.5);
  });

  it("sends the request object as the payload, filling in the default model", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    const request = { state: { a: 1 }, questions: { q1: noul("x") } };
    await client.systemOne(request);
    expect(requests[0]?.body).toEqual({ ...request, model: DEFAULT_MODEL });
    // Passing the same object with `model` set sends it byte-for-byte.
    await client.systemOne({ ...request, model: "explicit" });
    expect(requests[1]?.body).toEqual({ ...request, model: "explicit" });
  });

  it("sends NaN and infinities as strings", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    await client.systemOne({
      state: { value: Number.NaN, values: [1, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY] },
      questions: { q1: noul("x") },
    });
    expect(requests[0]?.body).toMatchObject({
      state: { value: "NaN", values: [1, "Infinity", "-Infinity"] },
    });
  });

  it("honors per-call model and client defaultModel", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch, defaultModel: "client-default" });
    await client.systemOne({ state: "s", questions: { q: choice("c", { a: null }) } });
    await client.systemOne({
      state: "s",
      questions: { q: choice("c", { a: null }) },
      model: "per-call",
    });
    expect(requests[0]?.body).toMatchObject({ model: "client-default" });
    expect(requests[1]?.body).toMatchObject({ model: "per-call" });
  });

  it("aborting the caller's signal aborts the signal handed to fetch, and wraps the error", async () => {
    const ac = new AbortController();
    const { fetch, requests } = mockFetch(() => {
      ac.abort();
      throw new DOMException("aborted", "AbortError");
    });
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    await expect(client.models.list({ signal: ac.signal })).rejects.toBeInstanceOf(
      APIUserAbortError,
    );
    expect(requests[0]?.init?.signal?.aborted).toBe(true);
  });

  it("wraps network failures in APIConnectionError with the cause", async () => {
    const boom = new TypeError("fetch failed");
    const { fetch } = mockFetch(() => {
      throw boom;
    });
    const client = new TypeSafeClient({ apiKey: "k", fetch, retry: { maxRetries: 0 } });
    const err = await client.models.list().catch((e: unknown) => e);
    expect(err).toBeInstanceOf(APIConnectionError);
    expect((err as APIConnectionError).cause).toBe(boom);
    expect((err as Error).message).toContain("fetch failed");
  });
});

describe("request compression", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  const state = "x".repeat(MIN_COMPRESSED_BODY_BYTES);

  const send = async (
    config: TypeSafeClientConfig = {},
    headers?: Record<string, string>,
    body: { state: string } = { state },
  ) => {
    const { fetch, requests } = mockFetch((req) =>
      json(req.init?.method === "GET" ? { models: [] } : SYSTEM_ONE_RESPONSE),
    );
    const client = new TypeSafeClient({ apiKey: "k", fetch, ...config });
    await client.systemOne({ ...body, questions: { q1: noul("?") } }, { headers });
    await client.models.list();
    const [post, get] = requests.map((r) => new Headers(r.init?.headers));
    return { client, requests, post, get };
  };

  it.each([
    [undefined, "zstd"],
    ["zstd", "zstd"],
  ] as const)("compression %s sends bodies as %s", async (compression, encoding) => {
    const { client, requests, post, get } = await send({ compression });
    expect(client.compression).toBe(encoding);
    expect(post?.get("content-encoding")).toBe(encoding);
    expect(requests[0]?.init?.body).toBeInstanceOf(Uint8Array);
    expect(requests[0]?.body).toMatchObject({ state });
    expect(get?.has("content-encoding")).toBe(false);
  });

  it("sends bodies under 1 KiB uncompressed", async () => {
    const { client, requests, post } = await send({}, undefined, { state: "x" });
    expect(client.compression).toBe("zstd");
    expect(post?.has("content-encoding")).toBe(false);
    expect(typeof requests[0]?.init?.body).toBe("string");
    expect(requests[0]?.body).toMatchObject({ state: "x" });
  });

  it("measures the body in UTF-8 bytes", async () => {
    // Each "é" is one UTF-16 code unit and two UTF-8 bytes.
    const accented = "é".repeat(MIN_COMPRESSED_BODY_BYTES / 2);
    const { post } = await send({}, undefined, { state: accented });
    expect(post?.get("content-encoding")).toBe("zstd");
  });

  it("compression false sends bodies uncompressed and drops a caller's Content-Encoding", async () => {
    const { requests, post } = await send({ compression: false }, { "content-encoding": "br" });
    expect(post?.has("content-encoding")).toBe(false);
    expect(typeof requests[0]?.init?.body).toBe("string");
    expect(requests[0]?.body).toMatchObject({ state });
  });

  it("replaces a caller's Content-Encoding with the one the body is compressed with", async () => {
    const { post } = await send({}, { "Content-Encoding": "br" });
    expect(post?.get("content-encoding")).toBe("zstd");
  });

  it("compresses multipart bodies", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: image(new Uint8Array(MIN_COMPRESSED_BODY_BYTES)),
      questions: { q1: noul("?") },
    });
    const headers = new Headers(requests[0]?.init?.headers);
    expect(headers.get("content-encoding")).toBe("zstd");
    expect(headers.get("content-type")).toMatch(/^multipart\/form-data; boundary=/);
    expect([...(requests[0]?.form?.keys() ?? [])]).toEqual(["request", "asset-0"]);
  });

  it("sends bodies uncompressed without zstd and rejects an explicit zstd", async () => {
    vi.spyOn(process, "getBuiltinModule").mockReturnValue({});
    const { client, requests, post } = await send();
    expect(client.compression).toBe(false);
    expect(post?.has("content-encoding")).toBe(false);
    expect(typeof requests[0]?.init?.body).toBe("string");
    expect(() => new TypeSafeClient({ apiKey: "k", compression: "zstd" })).toThrow(
      "zstd compression requires Node.js 22.15 or newer. Pass `compression: false` instead.",
    );
  });

  it.each(["gzip", "br"])("rejects compression %s", (compression) => {
    expect(
      () =>
        new TypeSafeClient({
          apiKey: "k",
          compression: compression as unknown as TypeSafeClientConfig["compression"],
        }),
    ).toThrow(`\`compression\` must be "zstd" or false, got "${compression}".`);
  });

  it("aborts while compressing the body", async () => {
    const controller = new AbortController();
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    // zstdCompress aborts the request and never calls back.
    vi.spyOn(process, "getBuiltinModule").mockReturnValue({
      zstdCompress: () => controller.abort(),
    });
    const err = await new TypeSafeClient({ apiKey: "k", fetch })
      .systemOne({ state, questions: { q1: noul("?") } }, { signal: controller.signal })
      .catch((e: unknown) => e);
    expect(err).toBeInstanceOf(APIUserAbortError);
    expect(requests).toHaveLength(0);
  });
});

describe("question builders", () => {
  it("choice accepts a criteria object as-is", () => {
    expect(choice("q", { a: "desc", b: null })).toEqual({
      type: "choice",
      instructions: "q",
      criteria: { a: "desc", b: null },
    });
  });

  it("choice rejects the removed label-list shorthand in JavaScript too", () => {
    expect(() => {
      // @ts-expect-error exercise plain JavaScript input
      choice("q", ["a", "b"]);
    }).toThrow(TypeSafeError);
  });

  it("noul allows describing one side, both, or neither", () => {
    expect(noul("q")).toEqual({ type: "noul", instructions: "q", criteria: undefined });
    expect(noul("q", { true: "yes means this" })).toEqual({
      type: "noul",
      instructions: "q",
      criteria: { true: "yes means this" },
    });
    expect(noul("q", { false: "no means this" }).criteria).toEqual({ false: "no means this" });
    expect(noul("q", { true: "a", false: "b" }).criteria).toEqual({ true: "a", false: "b" });
  });

  it("descriptions can be JSON objects, not only strings", () => {
    const rich = { summary: "warm", examples: ["hi!", "welcome"] };
    expect(choice("q", { friendly: rich, hostile: null }).criteria.friendly).toEqual(rich);
    expect(score("q", [rich, "meh"]).criteria[0]).toEqual(rich);
    expect(noul("q", { true: rich }).criteria?.true).toEqual(rich);
  });

  it("choice answers carry the winning label", async () => {
    const { fetch } = mockFetch(() =>
      json({
        model: "m",
        answers: {
          q: { type: "choice", choice: "b", confidence: 0.9, probabilities: { a: 0.1, b: 0.9 } },
        },
        usage: { input_tokens: 1, output_tokens: 1 },
      }),
    );
    const r = await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: "s",
      questions: {
        q: choice("q", { a: null, b: null }),
      },
    });
    expect(r.answers.q.choice).toBe("b");
  });

  it("box defaults its instructions to null", () => {
    expect(box("The dog")).toEqual({ type: "box", instructions: "The dog" });
    expect(box()).toEqual({ type: "box", instructions: null });
  });

  it("box answers carry the box, its confidence, and unmodeled fields", async () => {
    const answer = {
      type: "box",
      box: { top: 0.1, bottom: 0.6, left: 0.25, right: 0.75 },
      confidence: null,
    };
    const { fetch, requests } = mockFetch(() =>
      json({
        model: "m",
        answers: { dog: { ...answer, extra: { k: [1] } } },
        usage: { input_tokens: 1, output_tokens: 1 },
      }),
    );
    const r = await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: "s",
      questions: { dog: box({ find: "the dog" }) },
    });
    expect(requests[0]?.body).toMatchObject({
      questions: { dog: { type: "box", instructions: { find: "the dog" } } },
    });
    expect(r.answers.dog).toEqual({ ...answer, extra: { k: [1] } });
  });

  it("score keeps the list it was given and rejects maps", () => {
    expect(score("q", ["bad", "good"]).criteria).toEqual(["bad", "good"]);
    // biome-ignore lint/suspicious/noExplicitAny: deliberately malformed, as a JS caller might send
    expect(() => score("q", { 0: "bad", 1: "good" } as any)).toThrow(
      "Score criteria must be a list of descriptions indexed by score from zero, not a map.",
    );
  });
});

describe("image assets", () => {
  // 1x1 PNG.
  const PNG_BASE64 =
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=";
  const pngBytes = (): Uint8Array<ArrayBuffer> =>
    Uint8Array.from(atob(PNG_BASE64), (c) => c.charCodeAt(0));
  const PNG_ASSET = { type: "image", data_base64: PNG_BASE64 };

  /** The request body, with each asset's multipart file bytes base64-encoded into its entry. */
  const sentBody = async (req: RecordedRequest | undefined): Promise<unknown> => {
    const body = req?.body as { assets?: Record<string, { part: string }> } | undefined;
    if (req?.form === undefined || body?.assets === undefined) return body;
    const assets: [string, unknown][] = [];
    for (const [alias, { part, ...entry }] of Object.entries(body.assets)) {
      const bytes = await (req.form.get(part) as File).arrayBuffer();
      assets.push([alias, { ...entry, data_base64: Buffer.from(bytes).toString("base64") }]);
    }
    return { ...body, assets: Object.fromEntries(assets) };
  };

  /** The request body's `assets`, with multipart file bytes base64-encoded into each entry. */
  const sentBodyAssets = async (req: RecordedRequest | undefined): Promise<unknown> =>
    ((await sentBody(req)) as { assets?: unknown } | undefined)?.assets;

  /** Send `assets` through `systemOne` and return the request body's `assets`. */
  const sentAssets = async (assets: Record<string, Asset>): Promise<unknown> => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: Object.keys(assets).join(" "),
      questions: { q1: noul("?") },
      assets,
    });
    return sentBodyAssets(requests[0]);
  };

  it("sends assets keyed by named reference", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: "Inspect this returned product: <product>",
      questions: { q1: noul("Is the product damaged?") },
      assets: { "<product>": image(pngBytes()) },
    });
    expect(await sentBody(requests[0])).toEqual({
      state: "Inspect this returned product: <product>",
      model: DEFAULT_MODEL,
      questions: { q1: { type: "noul", instructions: "Is the product damaged?" } },
      assets: { "<product>": PNG_ASSET },
    });
  });

  it("sends images in state and question content under their references", async () => {
    const photo = image(pngBytes());
    const listing = image(pngBytes());
    expect(String(photo)).toMatch(/^<image:[0-9a-f]{32}>$/);
    expect(String(photo)).not.toBe(String(listing));
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: { photo },
      questions: { q1: noul(["Does it match the listing?", listing]) },
    });
    expect(await sentBody(requests[0])).toEqual({
      state: { photo: String(photo) },
      model: DEFAULT_MODEL,
      questions: {
        q1: { type: "noul", instructions: ["Does it match the listing?", String(listing)] },
      },
      assets: { [String(photo)]: PNG_ASSET, [String(listing)]: PNG_ASSET },
    });
  });

  it("sends images in withAssets text, including nested text, along with assets", async () => {
    const photo = image(pngBytes());
    const listing = image(pngBytes());
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: withAssets`Compare ${photo} with ${withAssets`listing ${listing}`} and <logo> (${1})`,
      questions: { q1: score(withAssets`Rate ${photo}`, ["bad", "good"]) },
      assets: { "<logo>": image(pngBytes()) },
    });
    expect(await sentBody(requests[0])).toMatchObject({
      state: `Compare ${photo} with listing ${listing} and <logo> (1)`,
      questions: { q1: { instructions: `Rate ${photo}` } },
      assets: { [String(photo)]: PNG_ASSET, [String(listing)]: PNG_ASSET, "<logo>": PNG_ASSET },
    });
  });

  it("sends images created by another copy of the SDK", async () => {
    vi.resetModules();
    const other = await import("../src/assets");
    const photo = other.image(pngBytes());
    expect(photo).not.toBeInstanceOf(image(pngBytes()).constructor);
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: photo,
      questions: { q1: noul("?") },
    });
    expect(await sentBodyAssets(requests[0])).toEqual({
      [String(photo)]: PNG_ASSET,
    });
  });

  it("sends images in assets under their own reference when it appears in a string", async () => {
    const photo = image(pngBytes());
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: `Compare <photo> with ${photo}`,
      questions: { q1: noul("Is it the same product?") },
      assets: { "<photo>": photo },
    });
    expect(await sentBodyAssets(requests[0])).toEqual({
      "<photo>": PNG_ASSET,
      [String(photo)]: PNG_ASSET,
    });
  });

  it("writes an image in content or withAssets text as its name when it is also in assets", async () => {
    const photo = image(pngBytes());
    const listing = image(pngBytes());
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: { photo, caption: withAssets`Inspect ${photo} beside ${listing}` },
      questions: { q1: noul([photo]), q2: noul(withAssets`Is ${withAssets`${photo}`} clear?`) },
      assets: { "<photo>": photo },
    });
    const body = await sentBody(requests[0]);
    expect(body).toMatchObject({
      state: { photo: "<photo>", caption: `Inspect <photo> beside ${listing}` },
      questions: { q1: { instructions: ["<photo>"] }, q2: { instructions: "Is <photo> clear?" } },
    });
    expect((body as { assets: object }).assets).toEqual({
      "<photo>": PNG_ASSET,
      [String(listing)]: PNG_ASSET,
    });
  });

  it("rejects before sending when a name in assets doesn't appear in the request", async () => {
    const photo = image(pngBytes());
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    await expect(
      client.systemOne({
        state: "Inspect <photo>",
        questions: { q1: noul("?") },
        assets: { "<photo>": photo, "<unused>": image(pngBytes()), '<"quoted">': photo },
      }),
    ).rejects.toThrow(
      'Assets not referenced in the request: <unused>, <"quoted">. ' +
        "Write each name in `assets` into `state`, question instructions, or criteria.",
    );
    // An image placed in content is written as its last name, so an earlier name is unreferenced.
    await expect(
      client.systemOne({
        state: photo,
        questions: { q1: noul("?") },
        assets: { "<first>": photo, "<second>": photo },
      }),
    ).rejects.toThrow("Assets not referenced in the request: <first>.");
    await client.systemOne({
      state: 'Inspect <"quoted">',
      questions: { q1: noul("?") },
      assets: { '<"quoted">': photo },
    });
    expect(requests).toHaveLength(1);
  });

  it("sends the request as it was when systemOne was called", async () => {
    const photo = image(new Blob([pngBytes()]));
    const bytes = pngBytes();
    const state: Record<string, unknown> = { note: "before", photo };
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const pending = new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: state as Record<string, Asset | string>,
      questions: { q1: noul("Is <bytes> clear?") },
      assets: { "<bytes>": image(bytes) },
    });
    state.note = "after";
    state.photo = image(pngBytes());
    bytes.fill(0);
    await pending;
    expect(await sentBody(requests[0])).toMatchObject({
      state: { note: "before", photo: String(photo) },
      assets: { "<bytes>": PNG_ASSET, [String(photo)]: PNG_ASSET },
    });
    const body = requests[0]?.body as { assets?: object } | undefined;
    expect(Object.keys(body?.assets ?? {})).toHaveLength(2);
  });

  it("rejects with a TypeError before sending when the request holds a cycle", async () => {
    const state: Record<string, unknown> = { photo: image(pngBytes()) };
    state.self = state;
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await expect(
      new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
        state: state as Record<string, Asset>,
        questions: { q1: noul("?") },
      }),
    ).rejects.toThrow(TypeError);
    expect(requests).toHaveLength(0);
  });

  it("attaches to withAssets text only the images whose references it contains", () => {
    const photo = image(pngBytes());
    const listing = image(pngBytes());
    const cycle: Record<string, unknown> = { photo };
    cycle.self = cycle;
    expect(withAssets`${{ photo }} ${cycle}`.assets).toEqual([]);
    expect(withAssets`${[photo, listing]}`.assets).toEqual([photo, listing]);
    expect(withAssets`${withAssets`${photo}`} ${{ listing }}`.assets).toEqual([photo]);
  });

  it("joins values with a separator and attaches the images among them", () => {
    const photo = image(pngBytes());
    const listing = image(pngBytes());
    const joined = withAssets.join([photo, "and", withAssets`${listing}`, null, 1], " ");
    expect(joined.text).toBe(`${photo} and ${listing}  1`);
    expect(joined.assets).toEqual([photo, listing]);
    expect(withAssets.join([photo, listing]).text).toBe(`${photo},${listing}`);
    expect(withAssets.join([]).text).toBe("");
    expect(withAssets`Compare ${withAssets.join([photo, listing], ", ")}`.assets).toEqual([
      photo,
      listing,
    ]);
  });

  it("sends images in withAssets.join text", async () => {
    const photo = image(pngBytes());
    const listing = image(pngBytes());
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: withAssets`Uploads: ${withAssets.join([photo, listing], ", ")}`,
      questions: { q1: noul(withAssets.join(["Is", photo, "clear?"], " ")) },
    });
    expect(await sentBody(requests[0])).toMatchObject({
      state: `Uploads: ${photo}, ${listing}`,
      questions: { q1: { instructions: `Is ${photo} clear?` } },
      assets: { [String(photo)]: PNG_ASSET, [String(listing)]: PNG_ASSET },
    });
  });

  it("sends assets named like a generated reference", async () => {
    const name = `<image:${"0".repeat(32)}>`;
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: `Inspect ${name}`,
      questions: { q1: noul("?") },
      assets: { [name]: image(pngBytes()) },
    });
    expect(await sentBodyAssets(requests[0])).toEqual({ [name]: PNG_ASSET });
  });

  it("rejects before sending when an untagged template literal interpolates an image", async () => {
    const photo = image(pngBytes());
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await expect(
      new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
        state: `Inspect ${photo}`,
        questions: { q1: noul("?") },
      }),
    ).rejects.toThrow(
      `Image references without an attached image: ${photo}. Tag template literals`,
    );
    expect(requests).toHaveLength(0);
  });

  it("encodes only the viewed bytes of ArrayBuffers and views", async () => {
    const padded = new Uint8Array([0, ...pngBytes(), 0]);
    expect(
      await sentAssets({
        "<a>": image(pngBytes().buffer),
        "<b>": image(padded.subarray(1, -1)),
        "<c>": image(new DataView(padded.buffer, 1, padded.length - 2)),
      }),
    ).toEqual({ "<a>": PNG_ASSET, "<b>": PNG_ASSET, "<c>": PNG_ASSET });
  });

  it("sends large data unchanged", async () => {
    const bytes = Uint8Array.from({ length: 100_000 }, (_, i) => i % 256);
    bytes.set([0xff, 0xd8, 0xff]);
    expect(await sentAssets({ "<a>": image(bytes) })).toEqual({
      "<a>": { type: "image", data_base64: Buffer.from(bytes).toString("base64") },
    });
  });

  it("decodes base64 text with Image.fromBase64", async () => {
    expect(await sentAssets({ "<a>": Image.fromBase64(PNG_BASE64) })).toEqual({ "<a>": PNG_ASSET });
  });

  it("rejects invalid or empty base64 text when Image.fromBase64 is called", () => {
    expect(() => Image.fromBase64("not base64!")).toThrow(
      "Image data must contain valid base64 text.",
    );
    expect(() => Image.fromBase64(`data:image/png;base64,${PNG_BASE64}`)).toThrow(
      "Image data must contain valid base64 text.",
    );
    expect(() => Image.fromBase64("")).toThrow("Image data is empty.");
  });

  it("sends images that aren't PNG or JPEG as application/octet-stream", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: "<a>",
      questions: { q1: noul("?") },
      assets: { "<a>": image(new TextEncoder().encode("GIF89a")) },
    });
    const part = requests[0]?.form?.get("asset-0") as File | undefined;
    expect(part?.type).toBe("application/octet-stream");
  });

  it("reads Blob data, ignoring its type", async () => {
    expect(
      await sentAssets({
        "<a>": image(new Blob([pngBytes()])),
        "<b>": image(new Blob([pngBytes()], { type: "image/gif" })),
      }),
    ).toEqual({ "<a>": PNG_ASSET, "<b>": PNG_ASSET });
  });

  it("sends a multipart body with the JSON request first and each image in its own part", async () => {
    const photo = image(pngBytes());
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: withAssets`Compare ${photo} with <listing>`,
      questions: { q1: noul("?") },
      assets: { "<listing>": image(new Blob([new Uint8Array([0xff, 0xd8, 0xff])])) },
    });
    const { init, raw: sentBody, body, form } = requests[0] ?? {};
    const headers = init?.headers as Record<string, string>;
    const [, boundary] =
      /^multipart\/form-data; boundary=([0-9a-f]{32})$/.exec(headers["Content-Type"] ?? "") ?? [];
    const raw = await (sentBody as Blob | undefined)?.text();
    expect(raw).toMatch(
      new RegExp(
        `^--${boundary}\r\nContent-Disposition: form-data; name="request"\r\n` +
          "Content-Type: application/json\r\n\r\n\\{",
      ),
    );
    expect(raw?.endsWith(`\r\n--${boundary}--\r\n`)).toBe(true);
    expect([...(form?.keys() ?? [])]).toEqual(["request", "asset-0", "asset-1"]);
    expect(body).toMatchObject({
      assets: {
        "<listing>": { type: "image", part: "asset-0" },
        [String(photo)]: { type: "image", part: "asset-1" },
      },
    });
    const listing = form?.get("asset-0") as File;
    const sent = form?.get("asset-1") as File;
    expect([listing.name, listing.type, sent.name, sent.type]).toEqual([
      "asset-0",
      "image/jpeg",
      "asset-1",
      "image/png",
    ]);
    expect(new Uint8Array(await listing.arrayBuffer())).toEqual(new Uint8Array([0xff, 0xd8, 0xff]));
    expect(new Uint8Array(await sent.arrayBuffer())).toEqual(pngBytes());
  });

  it("sends an image under each of its references in a separate part", async () => {
    const photo = image(pngBytes());
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({
      state: `Compare <photo> with ${photo}`,
      questions: { q1: noul("?") },
      assets: { "<photo>": photo },
    });
    expect(requests[0]?.body).toMatchObject({
      assets: { "<photo>": { part: "asset-0" }, [String(photo)]: { part: "asset-1" } },
    });
  });

  it.each([
    ["a Promise", Promise.resolve(new Uint8Array(1)), "Promise"],
    ["a Response", new Response("x"), "Response"],
    ["null", null, "null"],
    ["a number", 42, "number"],
    ["an array", [1, 2, 3], "Array"],
  ])("rejects %s as data", (_, data, name) => {
    expect(() => image(data as unknown as Uint8Array)).toThrow(
      `Image data must be file bytes or a Blob; got ${name}.`,
    );
  });

  it("rejects empty data", () => {
    expect(() => image(new Uint8Array(0))).toThrow("Image data is empty.");
    expect(() => image(new ArrayBuffer(0))).toThrow("Image data is empty.");
    expect(() => image(new Blob([]))).toThrow("Image data is empty.");
  });

  it("doesn't read Blob data when request options are invalid", async () => {
    const blob = new Blob([pngBytes()]);
    let reads = 0;
    blob.arrayBuffer = () => {
      reads++;
      return Promise.reject(new Error("file changed"));
    };
    const client = new TypeSafeClient({ apiKey: "k", fetch: mockFetch(() => json({})).fetch });
    await expect(
      client.systemOne(
        { state: "<a>", questions: { q1: noul("?") }, assets: { "<a>": image(blob) } },
        { timeout: 0 },
      ),
    ).rejects.toThrow(TypeSafeError);
    expect(reads).toBe(0);
  });

  it("sends an asset named __proto__", async () => {
    const assets = Object.fromEntries([["__proto__", image(pngBytes())]]);
    const sent = await sentAssets(assets);
    expect(Object.entries(sent as object)).toEqual([["__proto__", PNG_ASSET]]);
  });

  it("rejects with APIUserAbortError when aborted before or while reading a Blob", async () => {
    let reads = 0;
    const blob = new Blob([pngBytes()]);
    blob.arrayBuffer = () => {
      reads++;
      return new Promise(() => {});
    };
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    const send = (signal: AbortSignal) =>
      client.systemOne({ state: image(blob), questions: { q1: noul("?") } }, { signal });

    await expect(send(AbortSignal.abort())).rejects.toBeInstanceOf(APIUserAbortError);
    expect(reads).toBe(0);

    const ac = new AbortController();
    const pending = send(ac.signal);
    await vi.waitFor(() => expect(reads).toBe(1));
    ac.abort();
    await expect(pending).rejects.toBeInstanceOf(APIUserAbortError);
    expect(requests).toHaveLength(0);
  });

  it("rejects with the alias when a Blob can't be read", async () => {
    const blob = new Blob([pngBytes()]);
    blob.arrayBuffer = () => Promise.reject(new Error("file changed"));
    await expect(sentAssets({ "<a>": image(blob) })).rejects.toThrow(
      'Asset "<a>" could not be read: file changed',
    );
  });
});

describe("wire format", () => {
  it("preserves null instructions and criteria values", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const questions = {
      noul: noul(null, { true: "yes", false: null }),
      noCriteria: noul("q", null),
      choice: choice(null, { yes: null, no: null }),
      score: score(null, [null, "high"]),
    };
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({ state: "s", questions });
    expect(requests[0]?.body).toEqual({ model: DEFAULT_MODEL, state: "s", questions });
  });

  it("allows omitted instructions and preserves JSON arrays", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const questions = {
      noul: { type: "noul", criteria: { true: "yes" } },
      choice: { type: "choice", criteria: { yes: [null, { example: true }] } },
      score: { type: "score", criteria: [[null, "low"], null] },
      arrayInstructions: noul([null, { examples: [1, false] }], { true: ["yes", null] }),
      defaultInstructions: noul(undefined, { false: "no" }),
    } satisfies Questions;
    const state = [null, { messages: ["hello"] }];
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({ state, questions });
    expect(requests[0]?.body).toEqual({
      model: DEFAULT_MODEL,
      state,
      questions: {
        ...questions,
        defaultInstructions: { type: "noul", instructions: null, criteria: { false: "no" } },
      },
    });
  });

  const send = async (questions: Questions) => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    await new TypeSafeClient({ apiKey: "k", fetch }).systemOne({ state: "s", questions });
    const body = requests[0]?.body as
      | { questions: Record<string, { criteria: unknown }> }
      | undefined;
    return body?.questions ?? {};
  };

  it("sends choice criteria without rewriting", async () => {
    const wire = await send({ q: choice("which?", { a: null, b: null }) });
    expect(wire.q?.criteria).toEqual({ a: null, b: null });
  });

  it("sends a score list untouched", async () => {
    const wire = await send({ q: score("q", ["bad", "ok", "great"]) });
    expect(wire.q?.criteria).toEqual(["bad", "ok", "great"]);
  });

  it("rejects non-list score criteria, fewer than two criteria, and empty question sets before sending", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    // biome-ignore lint/suspicious/noExplicitAny: deliberately malformed, as a JS caller might send
    const bad = (criteria: any) =>
      client.systemOne({ state: "s", questions: { q: { type: "score", criteria } } });
    await expect(bad({ 0: "bad", 1: "ok" })).rejects.toThrow(TypeSafeError);
    await expect(bad({ 0: "bad", 1: "ok" })).rejects.toThrow(
      'Score question "q" has criteria that are not a list',
    );
    await expect(bad([])).rejects.toThrow(
      'Score question "q" has 0 criteria; at least two scores are required.',
    );
    await expect(bad(["only"])).rejects.toThrow("at least two scores");
    await expect(client.systemOne({ state: "s", questions: {} })).rejects.toThrow(
      "At least one question is required",
    );
    expect(requests).toHaveLength(0);
  });

  it("rejects empty or non-map choice criteria before sending", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    // biome-ignore lint/suspicious/noExplicitAny: deliberately malformed, as a JS caller might send
    const bad = (criteria: any) =>
      client.systemOne({ state: "s", questions: { q: { type: "choice", criteria } } });
    await expect(bad({})).rejects.toThrow(
      'Choice question "q" has no criteria; at least one choice is required.',
    );
    for (const criteria of [undefined, null, ["a", "b"], "a"]) {
      await expect(bad(criteria)).rejects.toThrow(
        'Choice question "q" has criteria that are not a map',
      );
    }
    expect(requests).toHaveLength(0);
  });

  it("rejects noul questions without instructions or a described outcome before sending", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    // biome-ignore lint/suspicious/noExplicitAny: deliberately malformed, as a JS caller might send
    const bad = (question: any) => client.systemOne({ state: "s", questions: { spam: question } });
    for (const question of [
      { type: "noul" },
      { type: "noul", instructions: null, criteria: {} },
      { type: "noul", criteria: { true: null, false: null } },
      { type: "noul", criteria: { true: undefined } },
    ]) {
      await expect(bad(question)).rejects.toThrow(
        'Noul question "spam" has neither instructions nor criteria; at least one is required.',
      );
    }
    await expect(bad({ type: "noul", criteria: "spam" })).rejects.toThrow(
      'Noul question "spam" criteria must be an object.',
    );
    await expect(bad({ type: "noul", instructions: "Spam?", criteria: ["spam"] })).rejects.toThrow(
      'Noul question "spam" criteria must be an object.',
    );
    expect(requests).toHaveLength(0);
  });

  it("rejects null or omitted state before sending", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    const questions = { spam: noul("Spam?") };
    // biome-ignore lint/suspicious/noExplicitAny: deliberately malformed, as a JS caller might send
    await expect(client.systemOne({ state: null, questions } as any)).rejects.toThrow(
      "State is required.",
    );
    // biome-ignore lint/suspicious/noExplicitAny: deliberately malformed, as a JS caller might send
    await expect(client.systemOne({ questions } as any)).rejects.toThrow("State is required.");
    expect(requests).toHaveLength(0);
  });

  it("returns a rejected promise instead of throwing when the request or options are invalid", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    const photo = image(new Uint8Array([1]));
    const calls = [
      () => client.systemOne({ state: "s", questions: {} }),
      () => client.systemOne({ state: `Inspect ${photo}`, questions: { q1: noul("?") } }),
      () => client.systemOne({ state: "s", questions: { q1: noul("?") } }, { timeout: -1 }),
      () => client.models.list({ retry: { maxRetries: -1 } }),
    ];
    for (const call of calls) {
      let promise: Promise<unknown> | undefined;
      expect(() => {
        promise = call();
      }).not.toThrow();
      const caught = await promise?.catch((err: unknown) => err);
      expect(caught).toBeInstanceOf(TypeSafeError);
    }
    const invalid = client.systemOne({ state: "s", questions: {} });
    await expect(invalid.asResponse()).rejects.toThrow(TypeSafeError);
    await expect(invalid.withResponse()).rejects.toThrow(TypeSafeError);
    expect(requests).toHaveLength(0);
  });
});

describe("1.0 primitive contract", () => {
  it("uses a ten-second default and keeps raw metadata access", async () => {
    const { fetch, requests } = mockFetch(() =>
      json(SYSTEM_ONE_RESPONSE, { headers: { "x-typesafe-request-id": "req_1" } }),
    );
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    expect(client.timeout).toBe(10000);
    const result = await client
      .systemOne({ state: "s", questions: { q1: noul("?") } })
      .withResponse();
    expect(result.data).toEqual(SYSTEM_ONE_RESPONSE);
    expect(result.requestId).toBe("req_1");
    expect(requests).toHaveLength(1);
  });

  it("forwards extra fields and null", async () => {
    const { fetch, requests } = mockFetch(() => json(SYSTEM_ONE_RESPONSE));
    const client = new TypeSafeClient({ apiKey: "k", fetch });
    const request = {
      state: "s",
      questions: { q: score("?", ["low", "high"]) },
      future_option: null,
      nested: { enabled: true },
    };
    await client.systemOne(request);
    expect(requests[0]?.body).toEqual({ ...request, model: "jev-latest" });
    await client.systemOne({ state: "s", questions: { q: noul("?") } });
    expect(requests[1]?.body).not.toHaveProperty("future_option");
  });
});
