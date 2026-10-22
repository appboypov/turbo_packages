# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-10-22

First release of a typed Dart client for Jev that matches the official JavaScript SDK 0.7.0 and Python SDK 0.7.5.

### Added
- `TJev` client that reads its API key and base URL and default model and log level from arguments or the `TYPESAFE_*` environment variables.
- `TJev.ask` sends State with Questions and Images to `/v1/systemone` and returns a `TurboResponse<TJevResult>`.
- Four typed Questions: `TJevNoul` and `TJevChoice` and `TJevScore` and `TJevBox`.
- Typed Answers read with `TJevResult.answer` with Probabilities and confidence and helpers such as `margin` and `normalizedScore` and `mostLikelyLevel`.
- `TJevImage` from bytes or base64 or a file. Images placed in content are sent as multipart and opt in to the Images Danger Zone.
- `TJev.models` lists the models of the account. `TJevModel` names Model Aliases and versions.
- Sealed `TJevFailure` types for every failure of normal use. Misuse throws a `TJev*Exception` before sending.
- `TJevRetryPolicy` with backoff and jitter and `Retry-After` support and a time budget. Every call takes a timeout and an Abort Trigger.
- Logging through the `turbo_jev` logger of `package:logging` with secret headers and secret JSON body fields replaced. `redactLoggedBodies` turns the body redaction off.
- Long-context Danger Zone opt-in and default headers and extra body fields.
- Gzip compression of bodies from 1 KiB outside the browser.
- Browser use behind your own proxy with `dangerouslyAllowBrowser`.
