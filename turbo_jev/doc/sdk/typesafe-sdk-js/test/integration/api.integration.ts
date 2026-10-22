import { describe, expect, it } from "vitest";
import {
  type APIError,
  AuthenticationError,
  BadRequestError,
  box,
  choice,
  ENV,
  Image,
  noul,
  score,
  TypeSafeClient,
  TypeSafeError,
  UnprocessableEntityError,
  withAssets,
} from "../../src";

/** Live API tests with raw response output; skipped unless `TYPESAFE_API_KEY` is set. */
const describeLive = process.env[ENV.apiKey] ? describe : describe.skip;

const show = (label: string, value: unknown): void => {
  console.log(`\n--- ${label} ---\n${JSON.stringify(value, null, 2)}`);
};

const sum = (values: Record<string, number>): number =>
  Object.values(values).reduce((a, b) => a + b, 0);

describeLive("live API", () => {
  const client = new TypeSafeClient({ logLevel: "info", timeout: 120_000 });

  const ticket = {
    subject: "Charged twice this month",
    body: "I see two charges of $49 on my card for August. I only have one account. Please fix this ASAP.",
  };

  it("lists models", async () => {
    const { data: models, requestId } = await client.models.list().withResponse();
    show("GET /v1/models", { requestId, count: models.length, first: models[0] });
    expect(requestId).toMatch(/^req_/);

    expect(Array.isArray(models)).toBe(true);
    expect(models.length).toBeGreaterThan(0);
    for (const m of models) {
      expect(typeof m.name).toBe("string");
      expect(typeof m.description).toBe("string");
      expect(typeof m.release_date).toBe("string");
    }
  });

  it("answers noul, choice, and score-as-list questions", async () => {
    const { data, requestId } = await client
      .systemOne({
        state: ticket,
        questions: {
          isBilling: noul("Is this ticket about billing?"),
          sentiment: choice("What is the customer's tone?", {
            calm: null,
            frustrated: null,
            angry: null,
          }),
          urgency: score("How urgent is this ticket?", ["can wait", "this week", "today"]),
        },
      })
      .withResponse();
    show("POST /v1/systemone", { requestId, data });

    expect(typeof data.model).toBe("string");
    // The API sends null token counts when it doesn't report usage.
    const { input_tokens, output_tokens } = data.usage;
    if (input_tokens !== null) expect(input_tokens).toBeGreaterThan(0);
    if (output_tokens !== null) expect(output_tokens).toBeGreaterThanOrEqual(0);

    const { isBilling, sentiment, urgency } = data.answers;
    expect(isBilling.type).toBe("noul");
    expect(isBilling.noul).toBeGreaterThanOrEqual(0);
    expect(isBilling.noul).toBeLessThanOrEqual(1);

    expect(sentiment.type).toBe("choice");
    expect(["angry", "calm", "frustrated"]).toContain(sentiment.choice);
    expect(Object.keys(sentiment.probabilities).sort()).toEqual(["angry", "calm", "frustrated"]);
    expect(sum(sentiment.probabilities)).toBeCloseTo(1, 1);
    expect(sentiment.confidence).toBeGreaterThanOrEqual(0);

    expect(urgency.type).toBe("score");
    expect(urgency.score).toBeGreaterThanOrEqual(0);
    expect(urgency.score).toBeLessThanOrEqual(2);
    expect(urgency.legend).toEqual({ 0: "can wait", 1: "this week", 2: "today" });
    expect(Object.keys(urgency.probabilities).sort()).toEqual(["0", "1", "2"]);
    expect(sum(urgency.probabilities)).toBeCloseTo(1, 1);
  });

  it("accepts rich descriptions and one-sided noul criteria", async () => {
    const data = await client.systemOne({
      state: ticket,
      questions: {
        duplicate: noul("Is the customer reporting a duplicate charge?", {
          true: { meaning: "the same amount charged more than once", examples: ["billed twice"] },
        }),
        tone: choice("Tone?", {
          calm: { summary: "measured", examples: ["please look into this"] },
          upset: null,
        }),
      },
    });
    show("rich descriptions", data.answers);
    expect(data.answers.duplicate.noul).toBeGreaterThanOrEqual(0);
    expect(Object.keys(data.answers.tone.probabilities).sort()).toEqual(["calm", "upset"]);
  });

  it("rejects a bad API key with AuthenticationError", async () => {
    const bad = new TypeSafeClient({
      apiKey: "not-a-real-key",
      retry: { maxRetries: 0 },
      logLevel: "off",
    });
    const err = await bad.models.list().catch((e: unknown) => e);
    show("bad key", { name: (err as Error).name, message: (err as Error).message });
    expect(err).toBeInstanceOf(AuthenticationError);
  });

  it("rejects an unknown model with a readable BadRequestError", async () => {
    const err = await client
      .systemOne(
        { state: "hello", questions: { q: noul("Is this a greeting?") }, model: "no-such-model" },
        { retry: { maxRetries: 0 } },
      )
      .catch((e: unknown) => e);
    show("unknown model", { name: (err as Error).name, message: (err as Error).message });
    expect(err).toBeInstanceOf(BadRequestError);
    expect((err as APIError).message).toBe("400 Unknown model: no-such-model");
    expect((err as APIError).requestId).toMatch(/^req_/);
  });

  it("surfaces server-side validation errors readably", async () => {
    // A description type the SDK does not validate but the API rejects, to see how a 422 renders.
    const malformed = { q: score("?", [123 as unknown as string, "ok"]) };
    const err = await client
      .systemOne({ state: "x", questions: malformed }, { retry: { maxRetries: 0 } })
      .catch((e: unknown) => e);
    show("422", { name: (err as Error).name, message: (err as Error).message });
    expect(err).toBeInstanceOf(UnprocessableEntityError);
    expect((err as Error).message).toMatch(/^422 questions\.q\.score\.criteria\.0/);
  });

  it("catches shapes the API would reject before sending", async () => {
    await expect(client.systemOne({ state: "x", questions: {} })).rejects.toThrow(TypeSafeError);
    // biome-ignore lint/suspicious/noExplicitAny: deliberately malformed, as a JS caller might send
    const empty: any = [];
    await expect(
      client.systemOne({ state: "x", questions: { q: score("?", empty) } }),
    ).rejects.toThrow(TypeSafeError);
  });
});

/** Live image tests; skipped unless `TYPESAFE_LIVE_IMAGES` is set, for an API that accepts images. */
const describeLiveImages =
  process.env[ENV.apiKey] && process.env.TYPESAFE_LIVE_IMAGES ? describe : describe.skip;

/** A 512x512 solid red PNG. */
const RED =
  "iVBORw0KGgoAAAANSUhEUgAAAgAAAAIAAQMAAADOtka5AAAABlBMVEX/AAAAAABBoxIDAAAANklEQVR42u3BAQEAAACCIP+v" +
  "bkhAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8G4IAAAFjdVCkAAAAAElFTkSuQmCC";

/** A 512x512 solid blue PNG. */
const BLUE =
  "iVBORw0KGgoAAAANSUhEUgAAAgAAAAIAAQMAAADOtka5AAAABlBMVEUAAP8AAAB7Yr8+AAAANklEQVR42u3BAQEAAACCIP+v" +
  "bkhAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8G4IAAAFjdVCkAAAAAElFTkSuQmCC";

/** A 512x512 white PNG with a red square from 128 to 384 pixels on each axis. */
const RED_SQUARE_ON_WHITE =
  "iVBORw0KGgoAAAANSUhEUgAAAgAAAAIAAQMAAADOtka5AAAABlBMVEX/////AADrWueTAAAAZ0lEQVR42u3MQQ0AAAgEoOtf" +
  "WiM4N/1BABIAAAAAAAAAgGM1EAgEAoFAIBAIBAKBQCAQCAQCgUAgEAgEAoFAIBAIBAKBQCAQCAQCgUAgEAgEAoFAIBAIBAKB" +
  "QCD4DgAAAAAAAAAAlhrvN+HSAmCw9gAAAABJRU5ErkJggg==";

describeLiveImages("live API images", () => {
  const client = new TypeSafeClient({
    logLevel: "info",
    timeout: 120_000,
    defaultHeaders: { "TypeSafe-Danger-Zone-Images": "true" },
  });

  it("answers about an image in state", async () => {
    const { answers } = await client.systemOne({
      state: ["Here is a photo:", Image.fromBase64(RED)],
      questions: { red: noul("Is the photo a solid red square?") },
    });
    show("inline image", answers);
    expect(answers.red.noul).toBeGreaterThan(0.5);
  });

  it("answers about an image in withAssets text that is also in assets", async () => {
    const photo = Image.fromBase64(RED);
    const { answers } = await client.systemOne({
      state: withAssets`Compare <photo> with ${photo}.`,
      questions: { same: noul("Are both photos the same?") },
      assets: { "<photo>": photo },
    });
    show("withAssets image also in assets", answers);
    expect(answers.same.noul).toBeGreaterThan(0.5);
  });

  it("answers about an image in question instructions", async () => {
    const { answers } = await client.systemOne({
      state: "Look at the image in the question.",
      questions: { red: noul(["Is this image a solid red square?", Image.fromBase64(RED)]) },
    });
    show("image in question", answers);
    expect(answers.red.noul).toBeGreaterThan(0.5);
  });

  it("compares the state image with images in question criteria", async () => {
    const { answers } = await client.systemOne({
      state: Image.fromBase64(RED),
      questions: {
        color: choice("Which sample has the same color as the state image?", {
          red: Image.fromBase64(RED),
          blue: Image.fromBase64(BLUE),
        }),
        similarity: score("How similar is the state image to the examples?", [
          Image.fromBase64(BLUE),
          Image.fromBase64(RED),
        ]),
      },
    });
    show("images in criteria", answers);
    expect(answers.color.choice).toBe("red");
    expect(answers.similarity.score).toBeGreaterThan(0.5);
  });

  it("locates the red square with a box question", async () => {
    const { answers } = await client.systemOne({
      state: Image.fromBase64(RED_SQUARE_ON_WHITE),
      questions: { redSquare: box("The red square in the center") },
      model: "jev-preview",
    });
    show("box", answers);
    const { type, box: coordinates, confidence } = answers.redSquare;
    const { top, bottom, left, right } = coordinates;
    expect(type).toBe("box");
    if (confidence !== null) expect(confidence).toBeGreaterThanOrEqual(0);
    for (const edge of [top, bottom, left, right]) {
      expect(edge).toBeGreaterThanOrEqual(0);
      expect(edge).toBeLessThanOrEqual(1);
    }
  });
});
