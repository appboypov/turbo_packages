# Question Objects Key Typed Answers

Dart has no literal types, so it cannot copy the JS SDK, which types `answers.topic` from the string key. A Question object is itself the key of its Answer: `result[topic]` returns the Answer type of that Question, and a Choice or Score typed on an enum or any value type returns those values. We rejected code generation (named fields, but a build step for every user) and string ids with casts (smallest API, but typos and wrong casts only fail at runtime).
