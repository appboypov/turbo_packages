# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-10-22

### Changed
- A debug record of a multipart Request holds only its `request` JSON part. `omittedBodyBytes` counts the Image parts, so Image bytes no longer reach the log.

## [0.1.0] - 2026-10-22

First release of a typed Dart client for Jev that matches the official JavaScript SDK 0.7.0 and Python SDK 0.7.5.

### Added
- `TJev` client that reads its API key and base URL and default model and log level from arguments or the `TYPESAFE_*` environment variables.
- `TJev.ask` sends State with Questions and Images to `/v1/systemone` and returns a `TurboResponse<TJevResult>`.
- Four typed Questions: `TJevNoul` and `TJevChoice` and `TJevScore` and `TJevBox`.
- `TJevQuestion.validate()` returns a `TurboResponse<void>`. A fail names the rule the Question breaks.
- Typed Answers read with `TJevResult.answer` with Probabilities and confidence and helpers such as `margin` and `normalizedScore` and `mostLikelyLevel`.
- `TJevImage` from bytes or base64 or a file. Images placed in content are sent as multipart and opt in to the Images Danger Zone.
- `TJevImage.fromFile` throws a `TJevInvalidImageException` when it cannot read the file. In a browser it always throws one.
- `TJev.models` lists the models of the account. `TJevModel` names Model Aliases and versions.
- Sealed `TJevFailure` types for every failure of normal use. Each failure has a `message` and the `TurboResponse` fail carries it too.
- Misuse throws before sending. Every package exception extends the sealed `TJevException` and has a `message`. So one `on TJevException catch` catches them all.
- `TJevRetryPolicy` with backoff and jitter and `Retry-After` support and a time budget. Every Request takes a timeout and an abort trigger.
- Logging through the `turbo_jev` logger of `package:logging` with secret headers replaced. Secret fields of JSON bodies and of the `request` part of multipart bodies are replaced too. `redactLoggedBodies` turns the body redaction off.
- A `TJevRetryLog` warning record before each retry, such as after a rate limit. A `TJevFailureLog` error record when a Request ends in a failure other than an abort. The log level decides which records the client logs.
- Long-context Danger Zone opt-in and default headers and extra body fields. The client checks extra body fields like the State.
- Gzip compression of bodies from 1 KiB outside the browser.
- Browser use behind your own proxy with `dangerouslyAllowBrowser`.
