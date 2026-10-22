import { describe, expectTypeOf, it } from "vitest";
import {
  type APIPromise,
  type Asset,
  type BoxResponse,
  box,
  type ChoiceResponse,
  choice,
  type EntryType,
  Image,
  image,
  type ModelCard,
  type NoulQuestion,
  type NoulResponse,
  noul,
  type Question,
  type RetryPolicy,
  type ScoreResponse,
  type SystemOneResult,
  score,
  type TextWithAssets,
  type TypeSafeClient,
  type WithResponse,
  withAssets,
} from "../src";

declare const client: TypeSafeClient;

describe("systemOne result inference", () => {
  it("maps each question to its response type with literal criteria keys", async () => {
    const r = await client.systemOne({
      state: "s",
      questions: {
        a: noul("x"),
        b: choice("y", { yes: null, no: "desc" }),
        c: score("z", ["bad", "ok"]),
        box: box(image(new Uint8Array())),
        rawBox: { type: "box" },
      },
    });

    expectTypeOf(r.answers.a).toEqualTypeOf<NoulResponse>();
    expectTypeOf(r.answers.box).toEqualTypeOf<BoxResponse>();
    expectTypeOf(r.answers.rawBox.box.top).toEqualTypeOf<number>();
    expectTypeOf(r.answers.rawBox.confidence).toEqualTypeOf<number | null>();
    expectTypeOf(r.answers.a.noul).toEqualTypeOf<number>();
    expectTypeOf(r.usage.input_tokens).toEqualTypeOf<number | null>();
    expectTypeOf(r.usage.output_tokens).toEqualTypeOf<number | null>();

    expectTypeOf(r.answers.b).toEqualTypeOf<
      ChoiceResponse<{ readonly yes: null; readonly no: "desc" }>
    >();
    expectTypeOf(r.answers.b.choice).toEqualTypeOf<"yes" | "no">();
    expectTypeOf(r.answers.b.probabilities).toEqualTypeOf<{
      readonly yes: number;
      readonly no: number;
    }>();

    expectTypeOf(r.answers.c).toEqualTypeOf<ScoreResponse<readonly ["bad", "ok"]>>();
    expectTypeOf(r.answers.c.score).toEqualTypeOf<number>();
    expectTypeOf(r.answers.c.legend).toEqualTypeOf<{ readonly 0: "bad"; readonly 1: "ok" }>();
    expectTypeOf(r.answers.c.probabilities).toEqualTypeOf<{
      readonly 0: number;
      readonly 1: number;
    }>();
    // @ts-expect-error score 2 was not defined
    r.answers.c.probabilities[2];

    // @ts-expect-error unknown choice key
    r.answers.b.probabilities.maybe;
    // @ts-expect-error unknown answer key
    r.answers.d;
    // @ts-expect-error stats was removed
    r.answers.a.stats;
    // @ts-expect-error assets_used was removed
    r.assets_used;
  });

  it("types score lists by index, with the legend keyed by score", async () => {
    const r = await client.systemOne({
      state: "s",
      questions: { c: score("z", ["bad", "ok", { rich: "great" }]) },
    });
    expectTypeOf(r.answers.c.probabilities).toEqualTypeOf<{
      readonly 0: number;
      readonly 1: number;
      readonly 2: number;
    }>();
    expectTypeOf(r.answers.c.legend).toEqualTypeOf<{
      readonly 0: "bad";
      readonly 1: "ok";
      readonly 2: { readonly rich: "great" };
    }>();
    expectTypeOf(r.answers.c.legend[2].rich).toEqualTypeOf<"great">();
    // @ts-expect-error score 3 was not defined
    r.answers.c.probabilities[3];
    // @ts-expect-error score 3 was not defined
    r.answers.c.legend[3];
  });

  it("degrades to numeric indexing for non-literal score lists", async () => {
    const list: [string, string, ...string[]] = ["a", "b"];
    const r = await client.systemOne({ state: "s", questions: { c: score("z", list) } });
    expectTypeOf(r.answers.c.probabilities).toEqualTypeOf<{ readonly [score: number]: number }>();
    expectTypeOf(r.answers.c.legend).toEqualTypeOf<{ readonly [score: number]: string }>();
  });

  it("accepts score lists built at runtime, with numeric indexing", async () => {
    const levels: string[] = ["bad", "ok", "great"];
    const r = await client.systemOne({ state: "s", questions: { c: score("z", levels) } });
    expectTypeOf(r.answers.c.probabilities).toEqualTypeOf<{ readonly [score: number]: number }>();
    expectTypeOf(r.answers.c.legend).toEqualTypeOf<{ readonly [score: number]: string }>();
    const mixed: readonly (string | null)[] = ["bad", null];
    expectTypeOf(score("z", mixed)).toMatchTypeOf<Question>();
    const numbers: number[] = [1, 2];
    // @ts-expect-error numbers are not valid descriptions
    score("q", numbers);
  });

  it("results are readonly", async () => {
    const r = await client.systemOne({ state: "s", questions: { a: noul("x") } });
    // @ts-expect-error readonly
    r.model = "other";
    // @ts-expect-error readonly
    r.answers.a.noul = 1;
    // @ts-expect-error readonly
    r.usage.input_tokens = 0;
    const models = await client.models.list();
    // @ts-expect-error readonly
    models[0].name = "other";
    // @ts-expect-error employee-only fields are available through raw access
    models[0].tags;
    expectTypeOf<ModelCard>().toEqualTypeOf<{
      readonly name: string;
      readonly description: string;
      readonly release_date: string;
    }>();
  });

  it("client settings are readonly", () => {
    // @ts-expect-error readonly
    client.defaultModel = "x";
    // @ts-expect-error readonly
    client.models = null;
    // @ts-expect-error readonly
    client.retry = {};
    // @ts-expect-error readonly
    client.retry.maxRetries = 0;
    expectTypeOf(client.retry).toEqualTypeOf<RetryPolicy>();
    expectTypeOf(client.retry.httpStatuses).toEqualTypeOf<ReadonlySet<number>>();
  });

  it("accepts a partial retry policy on the client and per call", () => {
    const partial: Partial<RetryPolicy> = { maxRetries: 1, httpStatuses: new Set([503]) };
    void partial;
    client.models.list({ retry: { httpStatuses: new Set([503]), backoffJitter: 0 } });
    // @ts-expect-error statuses are a set, as in the Python SDK
    client.models.list({ retry: { httpStatuses: [503] } });
    // @ts-expect-error unknown policy field
    client.models.list({ retry: { predicate: () => true } });
    // @ts-expect-error retry moved under the policy object
    client.models.list({ maxRetries: 0 });
  });
});

describe("criteria shapes", () => {
  it("rejects label-list shorthand for choice", () => {
    // @ts-expect-error criteria must be a map
    choice("q", ["a", "b"]);
    // @ts-expect-error empty label lists are not maps
    choice("q", []);
    const labels: string[] = ["a", "b"];
    // @ts-expect-error dynamic label lists are not maps
    choice("q", labels);
  });

  it("rejects numeric-keyed maps for score", () => {
    // @ts-expect-error score criteria must be a list
    score("q", { 0: "bad", 1: "ok" });
    // @ts-expect-error empty lists are not valid rubrics
    score("q", []);
    // @ts-expect-error a rubric needs at least two levels
    score("q", ["only"]);
    // @ts-expect-error inference is a client method, not a resource
    client.systemOne.run({ state: "s", questions: { q: noul("?") } });
  });
});

describe("question helpers", () => {
  it("constrains descriptions while allowing null for every question type", () => {
    // @ts-expect-error numbers are not valid descriptions
    choice("q", { yes: 1 });
    // @ts-expect-error numbers are not valid descriptions
    score("q", [1, 2]);
    score("q", ["ok", null]);
    noul(null, { true: "spam" });
    noul(undefined, { true: null, false: "ham" });
    noul("q", null);
    choice(null, { yes: null });
    score(null, [null, null]);
    choice("q", { yes: null, no: "ok", maybe: { detail: "rich" } });
    score("q", ["bad", "ok", { detail: "rich" }]);
    noul("q", { true: { detail: "rich" } });
    noul("q", { false: "only one side" });
  });

  it("requires noul instructions or a described outcome", () => {
    const instructions = undefined as EntryType | undefined;
    noul(instructions, { true: "spam" });
    // @ts-expect-error optional instructions need a described outcome
    noul(instructions);
    const criteria: NoulQuestion["criteria"] = { true: "spam" };
    // @ts-expect-error instructions or criteria are required
    noul();
    // @ts-expect-error instructions or criteria are required
    noul(null);
    // @ts-expect-error criteria must describe an outcome
    noul(null, {});
    // @ts-expect-error criteria must describe an outcome
    noul(null, { true: null, false: null });
    // @ts-expect-error the criteria type does not guarantee a described outcome
    noul(null, criteria);
    // @ts-expect-error criteria without a described outcome
    noul(null, null);
  });

  it("requires state", () => {
    // @ts-expect-error state cannot be null
    client.systemOne({ state: null, questions: { q: noul("?") } });
    // @ts-expect-error state is required
    client.systemOne({ questions: { q: noul("?") } });
  });

  it("preserves result inference with nulls, arrays, and omitted instructions", async () => {
    const r = await client.systemOne({
      state: "s",
      questions: {
        noul: { type: "noul", criteria: { true: "spam" } },
        choice: { type: "choice", criteria: { yes: null, no: [null, "example"] } },
        list: score(null, [null, "high"]),
        literal: { type: "score", criteria: [null, "high"] },
      },
    });
    expectTypeOf(r.answers.noul).toEqualTypeOf<NoulResponse>();
    expectTypeOf(r.answers.choice.choice).toEqualTypeOf<"yes" | "no">();
    expectTypeOf(r.answers.list.legend).toEqualTypeOf<{ readonly 0: null; readonly 1: "high" }>();
    expectTypeOf(r.answers.literal.legend).toEqualTypeOf<{
      readonly 0: null;
      readonly 1: "high";
    }>();
    expectTypeOf(r.answers.list.probabilities).toEqualTypeOf<{
      readonly 0: number;
      readonly 1: number;
    }>();
    client.systemOne({
      state: [null, { nested: [true, 1] }],
      questions: {
        q: noul([null, "instructions"], { true: [null, "criterion"] }),
        c: choice(["instructions"], { yes: [null, "criterion"] }),
        s: score(["instructions"], [[null, "criterion"], null]),
      },
    });
  });

  it("are all assignable to Question", () => {
    expectTypeOf(noul("x")).toMatchTypeOf<Question>();
    expectTypeOf(choice("x", { a: null })).toMatchTypeOf<Question>();
    expectTypeOf(choice("x", { a: null, b: null })).toMatchTypeOf<Question>();
    expectTypeOf(score("x", ["a", "b"])).toMatchTypeOf<Question>();
    expectTypeOf(box("x")).toMatchTypeOf<Question>();
  });
});

describe("image assets", () => {
  it("accept bytes and Blobs, or base64 text with Image.fromBase64", () => {
    expectTypeOf(image(new Uint8Array())).toEqualTypeOf<Asset>();
    expectTypeOf(image(new ArrayBuffer(1))).toEqualTypeOf<Asset>();
    expectTypeOf(image(new Blob([]))).toEqualTypeOf<Asset>();
    expectTypeOf(Image.fromBase64("aGk=")).toEqualTypeOf<Asset>();
    // @ts-expect-error base64 text goes through Image.fromBase64
    image("aGk=");
    // @ts-expect-error the format is detected from the bytes
    image(new Uint8Array(), "png");
  });

  it("are passed to systemOne inline, in withAssets text, or by reference", () => {
    const photo = image(new Uint8Array([1]));
    expectTypeOf(withAssets`Compare ${photo}`).toEqualTypeOf<TextWithAssets>();
    expectTypeOf(withAssets.join([photo, "text"], ", ")).toEqualTypeOf<TextWithAssets>();
    client.systemOne({ state: photo, questions: { q: noul([photo]) } });
    client.systemOne({
      state: { photos: [photo], caption: withAssets`${photo}` },
      questions: { q: score(withAssets`Rate ${photo}`, [null, { example: photo }]) },
    });
    client.systemOne({
      state: "<photo>",
      questions: { q: noul("?") },
      assets: { "<photo>": photo },
    });
    client.systemOne({
      state: "<photo>",
      questions: { q: noul("?") },
      // @ts-expect-error assets maps references to images
      assets: [photo],
    });
    client.systemOne({
      state: "<photo>",
      questions: { q: noul("?") },
      // @ts-expect-error assets must be created by image
      assets: { "<photo>": "aGk=" },
    });
  });

  it("type images and withAssets text in a score legend as strings", async () => {
    const photo = image(new Uint8Array([1]));
    const r = await client.systemOne({
      state: "s",
      questions: { q: score("z", [photo, withAssets`${photo}`, { examples: [photo] }]) },
    });
    expectTypeOf(r.answers.q.legend).toEqualTypeOf<{
      readonly 0: string;
      readonly 1: string;
      readonly 2: { readonly examples: readonly [string] };
    }>();
  });
});

describe("APIPromise", () => {
  it("client methods return APIPromise", () => {
    expectTypeOf(client.models.list()).toEqualTypeOf<APIPromise<ModelCard[]>>();
    const p = client.systemOne({ state: "s", questions: { a: noul("x") } });
    expectTypeOf(p).toEqualTypeOf<APIPromise<SystemOneResult<{ readonly a: NoulQuestion }>>>();
    expectTypeOf(p.withResponse()).toEqualTypeOf<
      Promise<WithResponse<SystemOneResult<{ readonly a: NoulQuestion }>>>
    >();
    expectTypeOf(p.asResponse()).toEqualTypeOf<Promise<Response>>();
  });

  it("awaiting yields the plain result", async () => {
    const r = await client.systemOne({ state: "s", questions: { a: noul("x") } });
    expectTypeOf(r).toEqualTypeOf<SystemOneResult<{ readonly a: NoulQuestion }>>();
    const { data, requestId } = await client
      .systemOne({ state: "s", questions: { a: noul("x") } })
      .withResponse();
    expectTypeOf(data.answers.a).toEqualTypeOf<NoulResponse>();
    expectTypeOf(requestId).toEqualTypeOf<string | undefined>();
  });
});
