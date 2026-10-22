# turbo_jev

turbo_jev lets Dart code ask Jev typed questions about content and use the typed answers directly.

## Language

### Service

**TypeSafe**:
The company and the HTTP service that runs Jev.
_Avoid_: TypeSafe AI API, the backend

**Jev**:
TypeSafe's System One model family, which answers Questions about State with Probabilities instead of generated text.
_Avoid_: LLM, the TypeSafe model

**Model Alias**:
A model name that points to a versioned Jev model, such as `jev-latest`.
_Avoid_: model tag, channel

**Danger Zone**:
An API feature that is off until the Request opts in, such as Images or long context.
_Avoid_: beta flag, experimental mode

**Usage**:
The input and output tokens TypeSafe counts for one Request.
_Avoid_: cost, billing

### Requests

**Request**:
One call to Jev that holds State, Questions, Images and a model.
_Avoid_: prompt, query, call

**State**:
The content a Request asks its Questions about: text or structured data.
_Avoid_: context, input, prompt

**Image**:
A picture sent with a Request and placed in State, Instructions or Criteria by its Image Reference.
_Avoid_: asset, attachment, file

**Image Reference**:
The token that stands for an Image wherever it appears in content.
_Avoid_: placeholder, image tag

### Questions

**Question**:
One typed judgment about the State: a Choice, a Noul, a Score or a Box.
_Avoid_: prompt, task, field

**Instructions**:
The part of a Question that says what to judge.
_Avoid_: prompt, question text

**Criteria**:
The part of a Question that defines its possible answers: Options, Levels or the meaning of true and false.
_Avoid_: labels, schema

**Choice**:
A Question that picks one Option from a defined set.
_Avoid_: classification, enum question

**Option**:
One possible answer of a Choice, with its description.
_Avoid_: label, class, category

**Noul**:
A Question that gives the Probability that a statement about the State is true.
_Avoid_: boolean, yes/no question, binary classification

**Score**:
A Question that places the State on ordered Levels.
_Avoid_: rating, scale question

**Level**:
One ordered, described position on a Score.
_Avoid_: rank, bucket, step

**Box**:
A Question that finds one region in an Image.
_Avoid_: detection, bounding box question

### Answers

**Answer**:
The typed result of one Question.
_Avoid_: response, output, prediction

**Probability**:
The chance Jev gives to an Option, a Level or to a Noul being true.
_Avoid_: score, likelihood

**Confidence**:
How much of an Answer's Probability sits on one result, from 0 (spread evenly) to 1 (all on one).
_Avoid_: certainty, accuracy, correctness
