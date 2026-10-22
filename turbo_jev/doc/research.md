# Jev (TypeSafe System One) knowledge inventory

Inventory of everything a Dart wrapper `turbo_jev` needs to cover to match the official SDKs. It holds facts only, no Dart design.

Sources and versions:

| Source | Version | Path |
| - | - | - |
| Docs mirror (130 pages, `llms.txt`, `llms-full.txt`) | snapshot | `typesafe/` |
| OpenAPI spec | 3.1.0, `info.version` 0.2.0 | `typesafe/openapi.json`, rendered at `typesafe/api/system-one.md:18-27` |
| JS SDK `@typesafe-ai/sdk` | 0.7.0 (`typesafe/sdk/javascript/changelog.md:7`) | `sdk/typesafe-sdk-js/` |
| Python SDK `typesafe-sdk` | 0.7.5 (`typesafe/sdk/python/changelog.md:9`) | `sdk/typesafe-sdk-python/` |

Citation rules: every path is relative to `turbo_jev/doc/`. `ts/` is short for `sdk/typesafe-sdk-js/src/`. `py/` is short for `sdk/typesafe-sdk-python/src/typesafe_sdk/`. Where docs and code disagree, the code wins; see section 8.

---

## 1. HTTP Contract

### 1.1 Endpoints

| Method and path | operationId | Success | Errors listed in spec | Source |
| - | - | - | - | - |
| `POST /v1/systemone` | `systemone_v1_systemone_post` | 200 `SystemOneResponse` | 422 `HTTPValidationError` | `typesafe/api/system-one.md:30-44`, `:147-223` |
| `GET /v1/models` | `models_v1_v1_models_get` | 200 `ModelMetadataList` | 422 `HTTPValidationError` | `typesafe/api/list-models.md:28-50` |

- Server: `https://api.typesafe.ai` (`typesafe/api/system-one.md:18-27`; `ts/client.ts:50`; `py/constants.py:15`).
- Auth: HTTP bearer, sent as `Authorization: Bearer <key>` (`typesafe/api/system-one.md:224-225`, `:895-898`).

### 1.2 Request headers

| Header | Who sets it | Meaning | Source |
| - | - | - | - |
| `Authorization: Bearer <key>` | SDK, protected | API key | `ts/client.ts:453-463`; `py/_core/transport.py:127-162` |
| `TypeSafe-Danger-Zone-Images: true` | caller | Required for any `assets` or any `box` question | `typesafe/api/system-one.md:46-53`; `typesafe/images.md:17-19` |
| `TypeSafe-Danger-Zone-Long-Context: true` | caller | Raises the request and per-question context limits to 262k | `typesafe/api/system-one.md:54-61`; `typesafe/models.md:35-37` |
| `Content-Type` | SDK, protected | `application/json`, or `multipart/form-data; boundary=...` when assets exist | `ts/client.ts:453-463`; `py/_core/endpoints.py:75-87` |
| `Content-Encoding` | SDK, protected | `zstd` when compression applies | `ts/client.ts:453-463`; `py/_core/transport.py:62-68` |
| `Accept: application/json` | SDK, protected | | `ts/client.ts:453-463` |
| `User-Agent`, `X-TypeSafe-SDK` | SDK, protected | `typesafe-sdk/<VERSION>` | `ts/client.ts:453-463`; `py/_core/constants.py:3-23` |
| `X-TypeSafe-Runtime` | SDK | JS: runtime name plus `(platform; arch)`. Python: `python/<ver> (<platform>; <machine>)` | `ts/runtime.ts:21-31`; `py/_core/transport.py:39` |
| `X-TypeSafe-Retry-Count` | SDK | Retry attempt number, only on retries | `ts/client.ts:467-468`; `py/_core/transport.py:88-96` |

Response header used by SDKs: `x-typesafe-request-id` (`ts/api-promise.ts:1`; `py/_core/schemas/base.py:63-94`), plus `retry-after-ms` and `Retry-After` (`ts/retry.ts:38-49`; `py/_core/errors.py:16-37`).

### 1.3 Request body formats

| Format | Shape | Source |
| - | - | - |
| `application/json` | `SystemOneRequest` | `typesafe/api/system-one.md:64-66` |
| `multipart/form-data` | First part named `request` with `application/json` holding `SystemOneRequest`. Each image is its own part. Each part has a unique non-empty name, used by exactly one asset (`asset.part`) | `typesafe/api/system-one.md:124-145`; `typesafe/images.md:179-184` |

Multipart part rules (`typesafe/images.md:179-184`):
- Part content type must be `image/png`, `image/jpeg`, `image/jpg`, `application/octet-stream`, or absent. Anything else returns 400.
- Part names are unique. `request` is reserved.
- One part per asset.

Generic body rules (`typesafe/api/errors.md:13-24`):

| Rule | Limit | Violation |
| - | - | - |
| Body size | 32 MiB, measured both compressed and decompressed | 413 |
| Encoding | UTF-8 JSON, no BOM | 400 |
| Nesting | At most 64 levels in each of `state`, `instructions`, `criteria` | 400 |
| Numbers | Finite only: no NaN, Infinity, or overflow such as `1e400` | 400 |
| `Content-Encoding` | `gzip`, `x-gzip`, or `zstd`; one layer only; zstd window at most 8 MiB | Unsupported or stacked: 415. Malformed: 400 |

### 1.4 Schemas

**SystemOneRequest** (`typesafe/api/system-one.md:228-282`)

| Field | Required | Type | Notes |
| - | - | - | - |
| `model` | yes | string | Alias or versioned ID |
| `state` | yes | string, object, or array | `x-accepts`; no audio or video (`typesafe/concepts/state.md:13-33`) |
| `questions` | yes | map of string to `Question` | minProperties 1 |
| `assets` | no | map of string to `Asset` | minProperties 1. Keys are opaque placeholders (a per-image UUID is recommended). A key is replaced wherever it appears as, or inside, a string in state, instructions, or criteria |

**SystemOneResponse** (`typesafe/api/system-one.md:283-318`)

| Field | Required | Type | Notes |
| - | - | - | - |
| `model` | yes | string | The resolved model. It may differ from the alias sent |
| `answers` | yes | map of question ID to `Answer` | minProperties 1 |
| `usage` | yes | `Usage` | |

**Usage** (`typesafe/api/system-one.md:408-429`): `input_tokens` and `output_tokens`, both required integers. Output tokens are free. Both SDKs allow `null`; see section 8.

**Question**: `oneOf` with discriminator `type` in `noul | choice | score | box` (`typesafe/api/system-one.md:338-355`).

| Question | Required | `instructions` | `criteria` | Source |
| - | - | - | - | - |
| `NoulQuestion` | `type` | Content or null | `NoulCriteria` or null. `NoulCriteria` has `true` and `false`, each Content or null | `typesafe/api/system-one.md:478-516`, `:820-850` |
| `ChoiceQuestion` | `type`, `criteria` | Content or null | Object, minProperties 1, maxProperties 255. Each value is Content or null | `typesafe/api/system-one.md:517-565` |
| `ScoreQuestion` | `type`, `criteria` | Content or null | Array, minItems 1, maxItems 10. Items are Content; null is not allowed | `typesafe/api/system-one.md:566-615` |
| `BoxQuestion` | `type` | Content or null | none | `typesafe/api/system-one.md:616-641` |

"Content" means string, object, or array, as JSON (`typesafe/primitives/advanced.md:11-20`; `ts/types.ts:16-38`; `py/_core/content_types.py:13-26`).

**Answer**: `oneOf` with discriminator `type` (`typesafe/api/system-one.md:390-407`).

| Answer | Required fields | Types | Source |
| - | - | - | - |
| `NoulAnswer` | `type`, `noul` | `noul`: number 0..1, probability of true | `typesafe/api/system-one.md:642-665` |
| `ChoiceAnswer` | `type`, `choice`, `confidence`, `probabilities` | `choice`: one criteria key. `probabilities`: map keyed by criteria key, sums to about 1 | `typesafe/api/system-one.md:666-714` |
| `ScoreAnswer` | `type`, `score`, `confidence`, `legend`, `probabilities` | `score`: number. `legend`: map `"0"`, `"1"`, ... to Content. `probabilities`: same keys as `legend` | `typesafe/api/system-one.md:715-781` |
| `BoxAnswer` | `type`, `box`, `confidence` | `box`: `BoxCoordinates`. `confidence`: number or null | `typesafe/api/system-one.md:782-819` |
| `BoxCoordinates` | `top`, `bottom`, `left`, `right` | numbers | `typesafe/api/system-one.md:851-890` |

**Asset** (`typesafe/api/system-one.md:356-389`; `typesafe/images.md:63-87`)

| Field | Notes |
| - | - |
| `type` | Const `"image"`. Optional |
| `format` | `png`, `jpg`, `jpeg`; lowercase; `jpeg` is an alias of `jpg`. Required with `data_base64`. The real format is detected from the bytes |
| `data_base64` | Standard base64 alphabet, `=` padding, no whitespace, no `data:` prefix |
| `part` | Name of a multipart part. If present, `data_base64` is ignored |

**HTTPValidationError** (`typesafe/api/system-one.md:319-337`, `:430-477`): `detail[]` of `ValidationError` with `loc` (array of string or int), `msg`, `type` (all required), plus optional `input` and `ctx`.

**ModelMetadataList** (`typesafe/api/list-models.md:28-50`; `ts/types.ts:218-222`; `py/_core/response_types.py:165-188`): `{ models: [{ name, description, release_date }] }`.

Example request and response bodies for each question type: `typesafe/api/system-one.md:67-123` and `:154-217`.

### 1.5 Models

| ID | Status | Context | Notes | Source |
| - | - | - | - | - |
| `jev-1.14.0` | current | 64k per request, 32k per question | Required for Box | `typesafe/models.md:11-31`; `typesafe/primitives/box.md:13` |
| `jev-1.13.0` | current | 64k per request, 32k per question | | `typesafe/models.md:11-31` |
| `jev-latest` | alias of `jev-1.13.0` | | SDK default model | `typesafe/models.md:66-75`; `ts/client.ts:51`; `py/constants.py:18` |
| `jev-preview` | alias of `jev-1.14.0` | | | `typesafe/models.md:66-75` |

- Long-context header raises both limits to 262k (`typesafe/models.md:35-37`).
- `GET /v1/models` lists only aliases; versioned IDs are still accepted (`typesafe/models.md:93-95`).
- Both versions accept images (`typesafe/images.md:61`).
- Rate limits are per organization, in tokens per second and requests per second. The SDKs honour `retry-after` (`typesafe/models.md:58-62`).

---

## 2. Question Types

### 2.1 Overview

| Type | Asks | Criteria | Answer value | Confidence | Source |
| - | - | - | - | - | - |
| Noul | Probability that a statement or question is true | Optional `{true, false}` descriptions | `noul` in 0..1 | None | `typesafe/primitives/noul.md:17-19`, `:105`, `:137` |
| Choice | Pick one option | Map of option key to description, 1 to 255 entries | `choice`, `probabilities` | Yes | `typesafe/primitives/choice.md:99-109` |
| Score | Place on an ordered scale | List of level descriptions, 1 to 10 in the API, "at least 2" in docs | `score` (weighted mean), `legend`, `probabilities` | Yes | `typesafe/primitives/score.md:51-65`, `:133-139`, `:224` |
| Box | Locate one region in an image | None, only instructions | `box` edges | Number or null | `typesafe/primitives/box.md:13-26`, `:71`, `:130-139` |

### 2.2 Details per type

**Noul**
- `criteria` is optional (`typesafe/primitives/noul.md:17-19`).
- A statement works as well as a question (`typesafe/primitives/noul.md:137`).
- Returns no `confidence` (`typesafe/primitives/noul.md:105`; `typesafe/confidence.md:112`).
- Threshold guidance: `typesafe/primitives/noul.md:107-118`.
- Both SDKs require `instructions` or at least one described outcome (`ts/questions.ts:24-36`, `:138-159`; `py/_core/question_types.py:107-113`; `py/_core/questions.py:10-49`).

**Choice**
- `choice` is the option with the highest probability; `probabilities` sum to 1 (`typesafe/primitives/choice.md:99-101`).
- Up to 255 options (`typesafe/primitives/choice.md:109`; `typesafe/api/system-one.md:517-565`).
- Criteria must be a map; JS throws on an array (`ts/questions.ts:70-78`).

**Score**
- Level number is its 0-based index (`typesafe/primitives/score.md:61`).
- `score` is the probability-weighted mean, so it can fall between levels (`typesafe/primitives/score.md:65`, `:133`, `:202`).
- `legend` maps each level number back to its description (`typesafe/primitives/score.md:134`).
- Python keys `legend` and `probabilities` by `int`; JS and the wire use strings (`typesafe/primitives/score.md:139`; `py/_core/response_types.py:44-58`; `ts/types.ts:136-165`).
- Normalize with `score / (len(criteria) - 1)` (`typesafe/primitives/score.md:307`).
- Criteria must be a list; JS throws on a map (`ts/questions.ts:46-62`).

**Box**
- Needs Jev 1.14 (`jev-preview` or `jev-1.14.0`) and the images header (`typesafe/primitives/box.md:13`; `typesafe/api/system-one.md:616-641`).
- Edges are fractions of the image, with `left < right` and `top < bottom` (`typesafe/primitives/box.md:71`).
- Always returns a box; there is no "not found". Pair it with a Noul to check presence (`typesafe/primitives/box.md:130`).
- One box per question (`typesafe/primitives/box.md:139`).
- JS helper `box(instructions = null)` (`ts/questions.ts:80-99`).

### 2.3 Shared rules

- `instructions`, choice values, score entries, and noul `true`/`false` all accept Content; nulls where the schema allows (`typesafe/primitives/advanced.md:11-20`).
- Question IDs are never sent to the model, so names carry no meaning (`typesafe/primitives.md:46-48`).
- No limit on question count; only context size limits it (`typesafe/primitives.md:190-194`; `typesafe/models.md:31`).
- Questions are independent and evaluated in parallel (`typesafe/primitives.md:78-81`, `:131-133`).
- Dependent questions need two requests (`typesafe/primitives.md:202-206`).

### 2.4 Confidence formulas

Confidence is 1 when all probability sits on one option and 0 when spread evenly (`typesafe/confidence.md:11`). Since every answer carries full `probabilities`, callers can compute their own measures (`typesafe/confidence.md:108`).

| Type | Formula | Source |
| - | - | - |
| Noul (client side only) | `abs(2p - 1)` | `typesafe/confidence.md:110-120` |
| Choice | `(p_max - 1/n) / (1 - 1/n)` | `typesafe/confidence.md:122-139` |
| Choice alternatives | top probability `p_max`; top-to-second ratio `p_max / p_second` | `typesafe/confidence.md:143-146` |
| Score | `max(0, 1 - sum(p_i * abs(i - m)) / MAD_unif)` with `m` the most likely level and `MAD_unif = (1/n) * sum(abs(i - (n-1)/2))` | `typesafe/confidence.md:148-200` |
| Box | Not documented | `typesafe/confidence.md` (absent) |

Note: Score confidence is measured around the most likely level `m`, while `score` is the weighted mean (`typesafe/confidence.md:150`; `typesafe/primitives/score.md:65`).

---

## 3. State and Assets

### 3.1 State

- String, object, or array of JSON. No audio or video (`typesafe/concepts/state.md:13-33`; `typesafe/api/system-one.md:228-282`).
- JS rejects a null state (`ts/client.ts:364-389`; `ts/types.ts:233-252`).
- Images can appear inside state, instructions, and criteria, including nested structured values (`typesafe/images.md:238-310`).

### 3.2 Image references on the wire

| Rule | Source |
| - | - |
| Images are off by default; send `TypeSafe-Danger-Zone-Images: true` | `typesafe/images.md:17-19` |
| Every asset key must be referenced somewhere, otherwise 400 | `typesafe/images.md:89-98` |
| Whole-value matches resolve first, then left-to-right matching without overlap | `typesafe/images.md:89-98` |
| Each use adds the image again (and costs tokens again) | `typesafe/images.md:89-98`, `:363-365` |
| Object keys are never replaced | `typesafe/images.md:89-98` |
| Answers echo the reference, not the image (for example a Score `legend`) | `typesafe/images.md:89-98` |
| A reference is at most 1024 bytes, all together at most 65,536 bytes, and cannot be empty or whitespace only | `typesafe/images.md:89-98` |

### 3.3 Image limits

| Limit | Value | Source |
| - | - | - |
| Formats | PNG or JPEG; no animated PNG | `typesafe/images.md:323-337` |
| File size | 16 MiB per image | `typesafe/images.md:323-337` |
| Dimensions | Each side 280 to 1568 px; total pixels 78,400 to 2,458,624 | `typesafe/images.md:323-337` |
| Request body | 32 MiB | `typesafe/images.md:323-337` |
| All images after processing | 32 MiB | `typesafe/images.md:323-337` |
| Expanded request | 32 MiB | `typesafe/images.md:323-337` |
| Resizing | Never; one bad image fails the whole request | `typesafe/images.md:323-337` |
| Metadata | EXIF stripped; orientation not applied | `typesafe/images.md:341-349` |
| Billing | Images count as input tokens | `typesafe/images.md:363-365` |
| Errors | 400 for missing header, rejected image, `max_tokens_exceeded`; 413 for size | `typesafe/images.md:369-376` |

### 3.4 How the SDKs model assets

| Concern | JS | Python |
| - | - | - |
| Asset type | `Asset = Image` (`ts/types.ts:108`) | `Asset = Image` (`py/_core/assets.py:273`) |
| Constructors | `image(Blob \| ArrayBuffer \| ArrayBufferView)` (`ts/assets.ts:154`); `Image.fromBase64` (`ts/assets.ts:86`) | `Image(bytes-like or PathLike)` (`py/_core/assets.py:73`); `Image.from_base64` ignores whitespace (`py/_core/assets.py:151`); `Image.from_pil(image, format="jpeg")`, quality 95 (`py/_core/assets.py:171`) |
| Reference token | `<image:` + 32 random lowercase hex + `>` (`ts/assets.ts:14`, `:23-26`) | `<image:{uuid4().hex}>`; same regex (`py/_core/assets.py:42`) |
| Text conversion | `toString` and `toJSON` return the reference (`ts/assets.ts:62-105`) | `__str__` returns the reference (`py/_core/assets.py:194-196`) |
| Placing images in text | `withAssets` tagged template and `withAssets.join(values, separator=",")` produce `TextWithAssets {text, assets}` (`ts/assets.ts:109-128`, `:183-210`) | f-strings with `str(image)`, made known by `client.attach_assets(...)`, a thread-safe ref-counted context manager (`py/_core/client/sync/client.py:111-143`; `py/_core/attached.py:12-49`) |
| Named assets | `assets: {name: image}` on the request; the name is written into content (`ts/types.ts:233-252`) | `assets=` kwarg on `system_one` (`py/_core/client/sync/client.py:145-271`) |
| Image objects placed directly in content | Serialized as their name if named in `assets`, else as their reference (`ts/assets.ts:232-290`) | Same, via a pydantic serializer and `References` context (`py/_core/assets.py:32-57`) |
| Validation | Empty data throws (`ts/assets.ts:62-105`) | Empty data rejected; `str` data rejected with a hint to use `from_base64` (`py/_core/assets.py:73-150`); blank alias rejected (`py/_core/assets.py:317-320`) |
| Unreferenced named asset | Throws "Assets not referenced in the request" (`ts/assets.ts:270-273`) | Not checked client side; server returns 400 (`typesafe/images.md:89-98`) |
| Reference without attached image | Throws, mentioning untagged template literals (`ts/assets.ts:284-287`) | Sent as plain text, no error (`py/_core/client/sync/client.py:116-119`) |
| Upload format | Always multipart. Parts named `asset-N`, one per alias, content type sniffed from magic bytes else `application/octet-stream` (`ts/assets.ts:8-11`, `:54-58`, `:377-396`) | Always multipart. Parts named `asset-{i}`, content type sniffed (`py/_core/endpoints.py:24-87`; `py/_core/assets.py:26`, `:345-348`) |
| Boundary | Random hex (`ts/assets.ts:310-340`) | `uuid4().hex` (`py/_core/multipart.py:19-28`) |
| Reading data | `Blob` read at send; bytes copied eagerly at call time (`ts/assets.ts:343-366`; `ts/client.ts:364-389`) | Lazy read once; async client reads files concurrently via anyio (`py/_core/assets.py:277-316`; `py/_core/client/aio/client.py:307`) |
| Empty `assets` | Omitted (`ts/assets.ts:232-290`) | Omitted (`py/_core/endpoints.py:67-69`) |
| Images header | Caller adds it per call with `{headers}` | Caller adds it with `extra_headers` (`typesafe/images.md:102-152`) |

A wrapper needs: an image value type from bytes, base64, and file; a unique reference token; a way to embed images in strings and structured content; reference scanning; multipart encoding with magic-byte sniffing; and the images header.

---

## 4. Client Features

### 4.1 Construction and configuration

| Option | JS (`TypeSafeClientConfig`, `ts/types.ts:302-334`; `ts/client.ts:313-336`) | Python (`TypeSafeClient`, `py/_core/client/sync/client.py:26-109`; `py/_core/config.py`) |
| - | - | - |
| API key | `apiKey`, else env `TYPESAFE_API_KEY`, else `TypeSafeError` | `api_key`, else env. Stripped; must be printable ASCII without spaces (`py/_core/config.py:31-38`). An explicit empty key does not fall back to env (`typesafe/sdk/python/usage/basic.md:523`) |
| Base URL | `baseURL`, else env `TYPESAFE_BASE_URL`; trailing slashes stripped (`ts/client.ts:317`) | `base_url`, else env |
| Default model | `defaultModel`, else env `TYPESAFE_DEFAULT_MODEL`, else `jev-latest` | `model`, else env, else `jev-latest` (`py/constants.py:3-18`) |
| Timeout | `timeout` ms, default 10000, must be positive (`ts/retry.ts:5`; `ts/client.ts:324`) | `timeout` seconds, default 10.0, positive and finite, or an `httpx2.Timeout`; inherited from a passed `http_client` (`py/constants.py:21`; `py/_core/config.py:41-44`; `py/_core/client/sync/client.py:90-91`) |
| Retry | `retry` partial `RetryPolicy` (`ts/client.ts:115-147`) | `retry` `RetryPolicy` |
| Default headers | `defaultHeaders` | `headers` |
| Compression | `compression: "zstd" \| false` | `compression` |
| Logging | `logLevel`, `logger` (`ts/client.ts:156-161`) | stdlib `logging`, logger `typesafe_sdk` |
| HTTP stack | `fetch` injection, required to exist (`ts/client.ts:328-329`) | `transport` or `http_client`, mutually exclusive, else `ValueError` (`py/_core/client/sync/client.py:88-89`); default limits 100 connections, keepalive 30 s (`py/_core/config.py:23`) |
| Browser guard | `dangerouslyAllowBrowser` (`ts/client.ts:68-73`, `:314`) | n/a |

Environment variables (`ts/env.ts:2-19`; `py/constants.py:3-12`): `TYPESAFE_API_KEY`, `TYPESAFE_BASE_URL`, `TYPESAFE_DEFAULT_MODEL`, `TYPESAFE_LOG_LEVEL`. JS trims values and treats blank as unset (`ts/env.ts:16-19`).

### 4.2 Calls

| Call | JS | Python |
| - | - | - |
| System One | `client.systemOne<const Q>(request, options): APIPromise<SystemOneResult<Q>>` (`ts/client.ts:364-389`) | `client.system_one(state, questions, *, model, assets, retry, timeout, extra_headers, extra_body, response_model)` (`py/_core/client/sync/client.py:145-271`) |
| List models | `client.models.list(options): APIPromise<ModelCard[]>`, unwraps `{models}`, throws `TypeSafeError` on another shape (`ts/resources/models.ts:15-28`) | `client.models.list(*, retry, timeout, extra_headers) -> ListModelsResponse` (`py/_core/client/sync/models.py:23-54`) |
| Per-call options | `RequestOptions {signal, timeout, retry, headers}` (`ts/types.ts:277-286`) | `retry`, `timeout`, `extra_headers`, `extra_body` |
| Extra body fields | Unknown properties on the request object are forwarded (`ts/types.ts:228-252`) | `extra_body` shallow-merged last; if it has `assets` the SDK skips its own (`py/_core/endpoints.py:24-72`) |
| Async | Promise only | Sync `TypeSafeClient` and `AsyncTypeSafeClient` with the same API (`py/_core/client/aio/client.py:51-63`) |
| Lifecycle | none | `close()` and context manager; async `aclose()`, `async with` (`py/_core/client/sync/client.py:276-286`; `py/_core/client/aio/client.py:313-323`) |

Before sending, both SDKs validate questions (section 5.1) and serialize the body. JS serializes eagerly and copies asset bytes, so later mutation does not change the request (`ts/client.ts:364-389`). JS reports validation failures as a rejected promise, not a synchronous throw (`ts/client.ts:271-274`, `:381-383`).

### 4.3 Header merging

- JS: default headers, then per-call headers. Case-insensitive, last wins, `undefined` deletes. Protected headers are set last and cannot be overridden (`ts/client.ts:174-186`, `:453-463`).
- Python: default headers, then per-call headers, then `X-TypeSafe-Retry-Count` removed, then protected headers set (`py/_core/transport.py:127-162`).

### 4.4 Compression

| Aspect | JS | Python |
| - | - | - |
| Algorithm | zstd only; gzip never used | zstd only |
| Availability | `node:zlib` with `zstdCompress` (Node 22.15+) (`ts/compression.ts:37-51`) | Python 3.14 `compression.zstd`, or `backports.zstd` extra (`py/_core/compression.py:9-38`) |
| Default | On if available | On if available |
| Explicit zstd without support | Throws | Errors |
| Threshold | Body at least 1024 bytes (`ts/compression.ts:5`) | At least 1024 bytes (`py/_core/transport.py:62-68`) |
| When | Once per request, reused across retries (`ts/client.ts:421-502`) | Once per request (`py/_core/transport.py:62-68`) |

### 4.5 Retries

| Setting | JS default (ms) `ts/retry.ts:11-23` | Python default (s) `py/_core/retry.py:36-126` |
| - | - | - |
| Max retries | `maxRetries` 2 | `max_retries` 2 |
| Initial backoff | `backoffInitialMs` 500 | `backoff_initial` 0.5 |
| Max backoff | `backoffMaxMs` 5000 | `backoff_max` 5.0 |
| Jitter | `jitter` 0.25 | `backoff_jitter` 0.25 |
| Statuses | 408, 429, 500-599 | 408, 429, 500-599 |
| Honour server delay | `respectRetryAfter` true | `respect_retry_after` true |
| Server delay cap | `maxRetryAfterMs` 60000 | none; server delay used unbounded (`py/_core/retry.py:111-116`) |
| Retry connection errors | `apiConnectionError` true | `api_connection_error` true |
| Retry timeouts | `apiTimeoutError` true | `api_timeout_error` true |
| Extra rules | none | `exceptions` set, `predicate` callable |
| Total budget | none | `timeout` 30.0 (stop before delay) (`py/_core/retry.py:82-86`) |
| Per-call override | Merged over client policy (`ts/client.ts:392-418`) | Replaces client policy entirely (`py/_core/transport.py:182`) |
| Validation | Non-negative integer retries, non-negative ms, jitter 0..1, statuses integer 100..999 (`ts/client.ts:115-147`) | `py/_core/retry.py:88-98` |

- Delay: server delay if allowed (and, in JS, at most `maxRetryAfterMs`); else `min(initial * 2^attempt, max) * (1 - random * jitter)` (`ts/retry.ts:56-68`; `py/_core/retry.py:27-33`).
- Server delay parsing: `retry-after-ms` first, then `Retry-After` as seconds or HTTP date (`ts/retry.ts:38-49`; `py/_core/errors.py:16-37`).
- JS sleep is abortable (`ts/retry.ts:71-83`). Python uses a copied tenacity retrying object per send (`py/_core/transport.py:172-199`).
- Docs: retry 429 and 529 with exponential backoff; the SDKs do (`typesafe/api/errors.md:38-42`; `typesafe/retries.md`).

### 4.6 Timeouts and cancellation

- JS: one `AbortController` per attempt; the timeout covers the whole buffered body (`ts/client.ts:189-213`, `:508-553`). A caller `signal` aborts with `APIUserAbortError`; a timeout gives `APITimeoutError`; network failure gives `APIConnectionError`.
- Python: httpx timeouts. `TimeoutException` becomes `TypeSafeAPITimeoutError`; `RequestError` becomes `TypeSafeAPIConnectionError` with a redacted message (`py/_core/transport.py:99-111`). No user-abort concept.

### 4.7 Response access

| Feature | JS | Python |
| - | - | - |
| Parsed result | `await client.systemOne(...)` gives `{model, answers, usage}` typed per question (`ts/types.ts:208-215`) | `SystemOneResponse` with `model`, `usage`, `answers` (`py/_core/response_types.py:117-148`) |
| Raw response | `.asResponse()` (`ts/api-promise.ts:41`) | `raw_http_response` (`py/_core/schemas/base.py:63-94`) |
| Data plus response plus request ID | `.withResponse()` gives `{data, response, requestId}` (`ts/api-promise.ts:7-14`, `:46`) | `request_id` property, raises if the header is absent (`py/_core/schemas/base.py:63-94`) |
| Transform | `.map(fn)` (`ts/api-promise.ts:52`) | n/a |
| Parsing | Lazy and memoized (`ts/api-promise.ts:21-78`); lenient: JSON, else text (`ts/client.ts:577-594`) | Lenient decode (`py/_core/json.py:30-36`); raises on non-2xx (`py/_core/schemas/base.py:101-118`) |
| Grouped views | n/a | `nouls`, `choices`, `scores`, `boxes`, cached (`py/_core/response_types.py:117-148`) |
| Custom response model | n/a | `response_model=` a `SystemOneResponse` subclass; fields named after question IDs are lifted from `answers` (`py/_core/response_types.py:112-113`, `:150-162`) |
| Unknown answer types | Passed through untyped | Warned about and skipped (`py/_core/response_types.py:94-114`) |

### 4.8 Logging

| Aspect | JS (`ts/logging.ts`) | Python (`py/_core/logging.py`) |
| - | - | - |
| Levels | `debug`, `info`, `warn`, `error`, `off`; default `warn` (`:5-7`) | `debug`, `info`, `warn`, `warning`, `error`, `off` (`:22-29`) |
| Unknown level | Throws (`:13-18`) | `py/_core/logging.py:97-106` |
| Sink | `consoleLogger` with `[typesafe-sdk]` prefix, or injected `logger` (`:24-47`) | Logger `typesafe_sdk` with `NullHandler`; env applied at import only |
| info | Request summary tagged `#N METHOD path`, retries, timeouts, aborts (`ts/client.ts:392-418`, `:469-497`) | Request summary with request ID, retries (`py/_core/transport.py:88-96`, `:113-124`) |
| debug | Headers and bodies (`ts/client.ts:469-497`) | Wire bodies truncated at 4096 bytes (`py/_core/transport.py:70-85`; `py/_core/constants.py:3-23`) |
| Redaction | `authorization`, `proxy-authorization`, `x-api-key` keep scheme plus last 4 chars if the secret is longer than 8; `cookie`, `set-cookie` become `***` (`:54-79`) | Secret headers (incl. `api-key`) plus any name containing `token` or `secret` fully replaced by `***` (`:32-38`); exceptions redacted (`:41-77`) |

---

## 5. Errors

### 5.1 Client-side validation before sending

| Check | JS (`ts/questions.ts:138-159`, `ts/client.ts:364-389`) | Python (`py/_core/questions.py:10-49`) |
| - | - | - |
| Empty question set | Reject | Reject |
| Null state | Reject | not checked |
| Choice criteria not a map, or empty | Reject | Reject empty; dict question needs `criteria` |
| Noul criteria not an object | Reject | Checked as in JS |
| Noul with neither instructions nor criteria | Reject | Reject |
| Score criteria not a list | Reject | dict question needs `criteria` |
| Score criteria length | Fewer than 2 rejected (`:152`) | Only empty rejected (`:32-35`) |
| Unknown question `type` | n/a (typed) | Dict with a nonempty string `type` passes through |
| Choice max 255, Score max 10 | Not enforced | Not enforced |
| Non-finite numbers | Converted to strings (`ts/assets.ts:245`) | Converted to strings (`py/_core/json.py:25-27`) |

### 5.2 HTTP status codes

| Status | Meaning | JS class (`ts/errors.ts:69-78`) | Python class (`py/_core/errors.py:118-149`, `:188-200`) | Retried by default |
| - | - | - | - | - |
| 400 | Bad request, including `max_tokens_exceeded`, missing images header, rejected image | `BadRequestError` | `TypeSafeBadRequestError` | no |
| 401 | Authentication | `AuthenticationError` | `TypeSafeAuthenticationError` | no |
| 403 | Permission denied | `PermissionDeniedError` | `TypeSafePermissionDeniedError` | no |
| 404 | Not found | `NotFoundError` | `TypeSafeNotFoundError` | no |
| 408 | Request timeout | `APIError` | `TypeSafeAPIError` | yes |
| 413 | Body or images too large | `APIError` | `TypeSafeAPIError` | no |
| 415 | Unsupported or stacked encoding | `APIError` | `TypeSafeAPIError` | no |
| 422 | Schema validation, `HTTPValidationError` | `UnprocessableEntityError` | `TypeSafeUnprocessableEntityError` | no |
| 429 | Rate limit | `RateLimitError` with `retryAfterMs` (`ts/errors.ts:92-95`) | `TypeSafeRateLimitError` with `retry_after_ms` | yes |
| 5xx | Server error | `InternalServerError` | `TypeSafeInternalServerError` | yes |
| 529 | Overloaded | `InternalServerError` | `TypeSafeInternalServerError` | yes |

Status meanings: `typesafe/api/errors.md:30-42`; `typesafe/images.md:369-376`.

### 5.3 Error hierarchy

| Kind | JS (`ts/errors.ts`) | Python (`py/_core/errors.py`) |
| - | - | - |
| Base | `TypeSafeError` (`:5`) | `TypeSafeError` (`:68`) |
| HTTP | `APIError {status, headers, body, requestId}` (`:42-79`) | `TypeSafeAPIError(status, body, headers, message, endpoint)` with `request_id`; `str` is `"{endpoint}: {status} {msg} (request_id=...)"` (`:72-115`) |
| Connection | `APIConnectionError` (`:100`) | `TypeSafeAPIConnectionError`, also a `ConnectionError` (`:152`) |
| Timeout | `APITimeoutError extends APIConnectionError {timeoutMs}` (`:107-115`) | `TypeSafeAPITimeoutError`, also a `TimeoutError`, with `.timeout` (`:156-173`) |
| User abort | `APIUserAbortError` (`:118`) | n/a |
| Response shape | `TypeSafeError` from `models.list` (`ts/resources/models.ts:15-28`) | `TypeSafeAPIResponseValidationError` with `field_path` in dotted form with `[i]` (`:176-185`; `py/_core/schemas/base.py:24-35`) |
| Config | `TypeSafeError` | `ValueError` for `transport` plus `http_client` |

### 5.4 Error message extraction

Both SDKs read the body in this order: `error` string, `error.message`, `message`, `detail` string, `detail.message`, then a `detail` array formatted as `loc: msg` joined with `; `, with a leading `body` dropped from `loc` (`ts/errors.ts:16-37`; `py/_core/errors.py:40-65`). Messages are truncated to 200 characters (`ts/errors.ts:39`; `py/_core/constants.py:3-23`).

---

## 6. Typing Tricks

### 6.1 JS (TypeScript)

| Trick | Effect | Source |
| - | - | - |
| `systemOne<const Q extends Questions>` | Keeps literal question IDs so `answers.<id>` is typed | `ts/client.ts:364` |
| `choice<const T>` | Keeps literal option keys; `choice` is `keyof T & string`, `probabilities` keyed by `T` | `ts/questions.ts:70-78`; `ts/types.ts:122-133` |
| `score<const T>` with overloads | Keeps tuple length; a literal list with fewer than 2 entries matches no overload; a runtime `string[]` is still accepted | `ts/questions.ts:46-62`; `ts/types.ts:77` |
| `ScoreCriteria = readonly [EntryType, EntryType, ...EntryType[]]` | Two-entry minimum at type level | `ts/types.ts:77` |
| `ScoreOf<T>` | Literal index keys (`"0" \| "1" \| ...`) for fixed tuples, else `number` | `ts/types.ts:136-138` |
| `SentContent<T>` | Turns `Image` values into `string` in `legend`, since answers echo references | `ts/types.ts:141-145` |
| `ResultFor<T>` | Conditional type with `infer` maps each question to its response type | `ts/types.ts:189-197` |
| `SystemOneResult<Q>` | Mapped type `{[K in keyof Q]: ResultFor<Q[K]>}` | `ts/types.ts:208-215` |
| `noul` overloads | Enforce instructions-or-described-outcome at compile time | `ts/questions.ts:24-36` |
| `Symbol.for` brands | `Image` and `TextWithAssets` detected across SDK copies | `ts/assets.ts:17-20` |
| Type tests | `test/types.test-d.ts` exists (not read) | `sdk/typesafe-sdk-js/test/` |

### 6.2 Python

| Trick | Effect | Source |
| - | - | - |
| Pydantic `Noul`, `Choice`, `Score`, `Box` with `extra="forbid"`; `None` omitted on the wire | Typed question builders | `py/_core/question_types.py:83-164` |
| Closed TypedDicts `NoulModel`, `ChoiceModel`, `ScoreModel`, `BoxModel`, `NoulCriteria` | Typed raw dict questions | `py/_core/question_types.py:14-80` |
| Noul `__init__` overloads | Instructions or described outcome required | `py/_core/question_types.py:107-113` |
| Discriminated union `Answer`; frozen, strict answers that ignore unknown fields | Narrow on `type` | `py/_core/response_types.py:79` |
| `response_model` with TypeVar and `system_one` overloads | Return type follows the model passed | `py/_core/client/sync/client.py:145-271` |
| `SystemOneResponse` subclass with fields named after question IDs | Answers lifted to typed top-level attributes | `py/_core/response_types.py:112-113`, `:150-162` |
| Grouped views `nouls`, `choices`, `scores`, `boxes` | Typed access by answer kind | `py/_core/response_types.py:117-148` |
| Typing tests | `tests/typing/` exists (not read) | `sdk/typesafe-sdk-python/tests/` |

What a Dart wrapper would need to reach parity: keep question IDs and Choice option keys typed, map each question kind to its answer kind, type Score level keys, and let callers declare a response shape by question ID.

---

## 7. JS vs Python Differences

| Area | JS 0.7.0 | Python 0.7.5 | Source |
| - | - | - | - |
| Concurrency model | Promise only | Sync and async clients | `ts/client.ts:364`; `py/_core/client/aio/client.py:51-63` |
| Units | Milliseconds | Seconds | `ts/retry.ts:5-23`; `py/constants.py:21`; `py/_core/retry.py:36-126` |
| Default timeout | 10000 ms per attempt | 10.0 s per attempt | same |
| Retry total budget | none | `timeout` 30.0 s | `py/_core/retry.py:82-86` |
| Retry-After cap | `maxRetryAfterMs` 60000 | none | `ts/retry.ts:11-23`; `py/_core/retry.py:111-116` |
| Extra retry rules | none | `exceptions`, `predicate` | `py/_core/retry.py:36-126` |
| Per-call retry | Merged | Replaced | `ts/client.ts:392-418`; `py/_core/transport.py:182` |
| Abort | `AbortSignal`, `APIUserAbortError` | none | `ts/types.ts:277-286`; `ts/errors.ts:118` |
| Raw response | `asResponse`, `withResponse`, `map` | `raw_http_response`, `request_id` (raises if absent) | `ts/api-promise.ts:41-52`; `py/_core/schemas/base.py:63-94` |
| Answer access | Inferred types per ID | Grouped views, `response_model` | `ts/types.ts:208-215`; `py/_core/response_types.py:117-162` |
| Score keys | String | Int | `ts/types.ts:136-165`; `py/_core/response_types.py:44-58` |
| Score minimum entries | 2 | 1 | `ts/questions.ts:152`; `py/_core/questions.py:32-35` |
| Raw dict questions | Known types only | Validated, unknown `type` forwarded | `py/_core/questions.py:10-49` |
| Unknown answer types | Passed through untyped | Warned and skipped | `py/_core/response_types.py:94-114` |
| Extra body | Extra request properties forwarded | `extra_body` | `ts/types.ts:228-252`; `py/_core/endpoints.py:24-72` |
| Per-call headers | `headers` | `extra_headers` | `ts/types.ts:277-286`; `py/_core/client/sync/client.py:145-271` |
| Images in text | `withAssets`, `withAssets.join` | `attach_assets` plus `str(image)` in f-strings | `ts/assets.ts:183-210`; `py/_core/client/sync/client.py:111-143` |
| Image sources | Bytes, `Blob` | Bytes, path, PIL | `ts/assets.ts:154`; `py/_core/assets.py:73-192` |
| Unreferenced asset | Throws | Server 400 | `ts/assets.ts:270-273` |
| Unknown reference in text | Throws | Sent as plain text | `ts/assets.ts:284-287`; `py/_core/client/sync/client.py:116-119` |
| Logging | `logLevel`, injectable `logger` | stdlib logging, env read at import | `ts/logging.ts`; `py/_core/logging.py:97-106` |
| Redaction | Keeps scheme and last 4 chars | Full `***`, also any `token`/`secret` header | `ts/logging.ts:54-79`; `py/_core/logging.py:32-38` |
| HTTP stack | `fetch` injection | httpx2 `transport` or `http_client`, HTTP/2, 100 connections, truststore SSL workaround in async | `ts/client.ts:328-329`; `py/_core/config.py:23`; `py/_core/client/aio/client.py:28-47` |
| Runtime header | Detects bun, deno, vercel-edge, cloudflare-workers, node, browser | `python/<ver> (<platform>; <machine>)` | `ts/runtime.ts:21-31`; `py/_core/transport.py:39` |
| Browser guard | `dangerouslyAllowBrowser` | n/a | `ts/client.ts:68-73` |
| Error types | `APIError` tree, `APIUserAbortError` | Also `TypeSafeAPIResponseValidationError`, `endpoint` in errors, builtin `ConnectionError`/`TimeoutError` bases | `ts/errors.ts`; `py/_core/errors.py` |
| Timeout config | Positive number per call | Number or `httpx2.Timeout` | `ts/client.ts:324`; `py/_core/config.py:41-44` |
| Bad models list shape | `TypeSafeError` | Response validation error | `ts/resources/models.ts:15-28` |
| Lifecycle | none | `close`/`aclose`, context managers | `py/_core/client/sync/client.py:276-286` |

---

## 8. Docs vs Code Disagreements

Code is the authority in every row.

| # | Topic | Docs say | Code does | Sources |
| - | - | - | - | - |
| 1 | Score criteria minimum | "should have at least two" | JS requires 2; Python and OpenAPI accept 1 | `typesafe/primitives/score.md:51`; `ts/questions.ts:152`; `py/_core/questions.py:32-35`; `py/_core/question_types.py:136`; `typesafe/api/system-one.md:600` |
| 2 | Null Score entries | `advanced.md` table allows null for every criteria value | OpenAPI Score items exclude null; JS `EntryType` allows null | `typesafe/primitives/advanced.md:19`; `typesafe/api/system-one.md:598`; `ts/types.ts:32-38` |
| 3 | Usage token types | OpenAPI: required integers | Both SDKs allow null (JS changelog "allow null token counts") | `typesafe/api/system-one.md:408-429`; `ts/types.ts:200-205`; `py/_core/response_types.py:83-91`; `typesafe/sdk/javascript/changelog.md` |
| 4 | Box confidence | Reads as always a number | OpenAPI and both SDKs allow null | `typesafe/primitives/box.md:72`; `typesafe/api/system-one.md:782-819`; `ts/types.ts:180-186`; `py/_core/response_types.py:67-76` |
| 5 | Python log levels | debug, info, warning, error, off | Also accepts `warn` | `typesafe/sdk/python/usage/advanced.md:144`; `py/_core/logging.py:22-29` |
| 6 | Retry timeout | Docs describe one retry policy | JS has no total budget; Python `RetryPolicy.timeout=30.0` is a total budget | `ts/types.ts:255-281`; `py/_core/retry.py:82-86` |
| 7 | Compression | API accepts gzip, x-gzip, zstd | Both SDKs only send zstd | `typesafe/api/errors.md:24`; `ts/compression.ts:37-51`; `py/_core/compression.py:9-38` |
| 8 | Score/Choice maximums | Choice up to 255, Score up to 10 | Neither SDK enforces them; server does | `typesafe/primitives/choice.md:109`; `typesafe/primitives/score.md:224`; `ts/questions.ts:138-159`; `py/_core/questions.py:10-49` |
| 9 | Unreferenced assets | Server returns 400 | JS fails early; Python leaves it to the server | `typesafe/images.md:89-98`; `ts/assets.ts:270-273` |
| 10 | Unknown image references | not covered | JS throws; Python sends plain text | `ts/assets.ts:284-287`; `py/_core/client/sync/client.py:116-119` |
| 11 | `/v1/models` errors | OpenAPI lists only 422 | SDKs map every status through the normal error table | `typesafe/api/list-models.md:28-50`; `ts/errors.ts:69-78` |
| 12 | Model IDs in cookbooks | `models.md` lists only 1.13.0 and 1.14.0 | Cookbooks use `jev-1.12` | `typesafe/models.md:11-31`; `typesafe/cookbooks/hierarchical_classification.md:626`; `typesafe/cookbooks/autoformat.md:65` |
| 13 | Base URL env in cookbooks | SDK reads `TYPESAFE_BASE_URL` | Many cookbooks pass `base_url=os.environ.get("TYPESAFE_ENDPOINT")` themselves | `py/constants.py:3-12`; `typesafe/cookbooks/twitch_chat_filter.md:75`; `typesafe/cookbooks/rerank_typesafe.md:214` |
| 14 | Image dates | Basic usage dates images "as of November 14, 2026" | Changelog dates 0.7.5 to 2026-10-14 | `typesafe/sdk/python/usage/basic.md:127`; `typesafe/sdk/python/changelog.md:9` |

Consistent items worth noting:
- 529 is retried by both SDKs because 500-599 is in the default status set (`typesafe/api/errors.md:38-42`; `ts/retry.ts:11-23`).
- Asset `type` is optional in both docs and OpenAPI (`typesafe/images.md:73`; `typesafe/api/system-one.md:356-389`).
- Both SDKs omit an empty `assets` map, matching minProperties 1 (`py/_core/endpoints.py:67-69`; `ts/assets.ts:232-290`).
- JS and Python both require instructions or criteria for Noul, matching the docs (`ts/questions.ts:24-36`; `py/_core/question_types.py:107-113`).

---

## 9. Patterns Worth Supporting

| Pattern | What callers do | What it needs from a wrapper | Source |
| - | - | - | - |
| Speculative fan-out | Send every question the decision tree might need in one request, then branch in code on `choice`, `score`, `noul` | Mixed question maps; typed answer access by ID | `typesafe/patterns/fan-out.md:9-83` |
| Confidence-gated routing | Gate on Choice `confidence` with a floor (0.6) and higher per-action thresholds (0.85) | `confidence` on Choice and Score answers | `typesafe/patterns/confidence-routing.md:41-66` |
| Composite scoring | Several Scores, each normalized to 0..1, then weighted sums per role | Score `score` plus criteria length for normalization | `typesafe/patterns/composite-scoring.md:42-57`; `typesafe/primitives/score.md:307` |
| Intent routing | Choice for intent plus Score for complexity, with confidence checks on both | Choice and Score in one request; confidence on both | `typesafe/patterns/intent-routing.md:47-75` |
| Presence plus location | Noul "is it there" plus Box "where" | Box with images header and `jev-preview`; Noul in same request | `typesafe/primitives/box.md:130` |
| Hierarchical classification | Walk a taxonomy with Choice `probabilities` and beam search | Full `probabilities` map; many sequential and parallel requests | `typesafe/primitives/advanced.md:55-65`; `typesafe/cookbooks/hierarchical_classification.md:626-780` |
| Two-step dependency | Second request built from the first answer | Chaining requests | `typesafe/primitives.md:202-206` |
| Custom confidence | Top probability, top-to-second ratio, Noul `abs(2p-1)` | Full `probabilities` on every answer | `typesafe/confidence.md:108-146` |
| Batching questions | One request with many questions is 12.2x cheaper and 10.0x faster | Large question maps | `typesafe/cookbooks.md:67` |
| Concurrent requests | Thread pools of 4 to 16 workers sharing one client, with client timeouts of 30 to 120 s | Safe concurrent use of one client; long timeouts | `typesafe/cookbooks/twitch_chat_filter.md:73-76`, `:319`; `typesafe/cookbooks/rerank_typesafe.md:210-215`, `:430`; `typesafe/cookbooks/consistency_choice_cookbook.md:99-102`, `:537` |
| Heavier retry | `RetryPolicy(max_retries=5, backoff_initial=1.0, backoff_max=20.0)` | Configurable retry policy | `typesafe/cookbooks/hierarchical_classification.md:629` |
| Images in content | Images inside state, instructions, criteria, also nested | Image values usable anywhere in Content | `typesafe/images.md:238-310` |
| Reading the resolved model | Cookbooks compare `response.model` to the requested model | `model` on the response | `typesafe/cookbooks/consistency_choice_cookbook.md:433`, `:564-568` |

Cookbook index by problem area: `typesafe/cookbooks.md:15-68`.
