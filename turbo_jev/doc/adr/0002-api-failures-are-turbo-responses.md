# API Failures Are TurboResponses

Both official SDKs throw on a failed Request. turbo_jev returns a `TurboResponse` fail with a typed error for every failure that normal use can cause: no network, timeout, rate limit, wrong key or a rejected Request. This follows our results convention, so callers handle failures with `when` and cannot forget a try/catch. Mistakes in the code that uses turbo_jev, such as a Choice without Options, still throw a `TJevException`, so cookbook code that relies on catching API exceptions does not port one to one.
