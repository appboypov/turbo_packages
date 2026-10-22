# API Failures Are TurboResponses

Both official SDKs throw on a failed call. turbo_jev returns a `TurboResponse` fail with a typed error for every failure that normal use can cause: no network, timeout, rate limit, wrong key or a rejected Request. This follows our results convention, so callers handle failures with `when` and cannot forget a try/catch. Mistakes in calling code, such as a Choice without Options, still throw, so cookbook code that relies on catching API exceptions does not port one to one.
