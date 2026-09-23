# turbo_promptable

Object-Oriented Prompting framework for the turbo ecosystem. Define AI agent prompts, roles, workflows, and tools as type-safe Dart objects that serialize to JSON, YAML, Markdown, and XML.

## Features

- Type-safe workspace models: `TRole`, `TPersona`, `TWorkflow`, `TStep`, `TInstruction`, `TInput`, `TOutput`, `TGoal`, `TEndGoal`, `TIssue`, `TContext`, `TTemplate`, `TTool`, and more
- Spec models: `TAbility`, `TFeature`, `TRequirement`, `TScenario`, `TJourney`, `TModule`, `TMockup`, `TPrototype`
- Local tasks: `TTask` backed by `TTaskDto`, with a nullable `TResultDto` once finished
- Tool models: `TApi`, `TCli`, `TScript`, `TMcp`, and `TToolSet`, each carrying a list of `TToolAbility`
- Spawnable abstraction (`TSpawnable`, extended by `TAgent`) carrying `id`, `allowedTools`, `yolo`, `model`, and `headless`, with a `spawn` method that builds a launch command via a `TCliTool` for tools like Claude Code, Cursor, Windsurf, and custom CLIs
- Cross-referencing abstracts (`TOfAbilities`, `TOfFeatures`, `TOfIssues`, `TOfJourneys`, `TOfMockups`, `TOfModules`, `TOfPrds`, `TOfProjects`, `TOfPrototypes`, `TOfScenarios`) for composing specs
- JSON serialization on every model via `json_serializable`; YAML, Markdown, and XML output inherited from [`turbo_serializable`](https://pub.dev/packages/turbo_serializable)
- Structured metadata (`TMetaData`) on every promptable

## Installation

```yaml
dependencies:
  turbo_promptable: ^0.6.0
```

## Usage

```dart
import 'package:turbo_promptable/turbo_promptable.dart';

const workflow = TWorkflow(
  name: 'Review Workflow',
  endGoal: TEndGoal(
    'A reviewed, higher-quality codebase',
    name: 'Quality Review',
  ),
  steps: [
    TStep(
      name: 'Analyse',
      input: TInput(name: 'Source Code'),
      instructions: 'Analyse the provided source code for quality issues.',
      output: TOutput(
        name: 'Analysis Report',
        schema: 'markdown',
      ),
    ),
  ],
);

const persona = TPersona(
  name: 'Code Reviewer',
  expertise: 'Static analysis and code quality',
  identity: 'A meticulous reviewer focused on maintainability.',
);

void main() {
  print(workflow.toJson());
  print(persona.toJson());
}
```

## Core Concepts

### TPromptable

Every workspace model extends `TPromptable`, which itself extends `TSerializable` from `turbo_serializable`. Models have:

- `name` — required identifier
- `metaData` — optional `TMetaData` for frontmatter (description, tags, etc.) on models that declare it

### Roles and Personas

- `TRole` — a capability bundle with required `expertise`, plus optional `instructions` and `tools`
- `TPersona` — a `TRole` augmented with an `identity` string that describes the persona's character; construct via `TPersona(...)` or `TPersona.fromRole(role: ..., identity: ...)`

### Workflows and Steps

A `TWorkflow` contains an ordered list of `TStep`s and a required `TEndGoal`. Each `TStep` has a required `TInput`, a string `instructions` field, and a required `TOutput`.

### Specs

Spec models (`TAbility`, `TFeature`, `TRequirement`, `TScenario`, `TJourney`, `TModule`, `TMockup`, `TPrototype`) describe intended behaviour and deliverables. They cross-reference each other via the `TOf*` abstracts exported from `workspace/abstracts/`.

### Tools

Tool subclasses (`TApi`, `TCli`, `TScript`, `TMcp`) extend the shared `TTool` base, which carries a list of `TToolAbility`s. `TTool.asToolSet(...)` converts a tool into a `TToolSet`.

### Spawnable

`TSpawnable` (extended by `TAgent`, `TRole`, `TTask` and `TIssue`) carries an `id` and an optional `TSpawnConfigDto`: a raw command, or tool, model, system prompt, skills, effort and working folder. `TSpawnSettings` holds the plx spawn settings: search folders per concept, the default agent, tool and working folder, and the first-message builders.

### Trigger settings

`TTriggerSettings` holds the plx trigger settings: a list of `TTriggerKindDto`. Each kind has a unique `name`, a pattern (`start`, optional `contains`, `end`) and an optional shell `command`. The plx server runs that command once for each finished trigger of the kind. The optional `ignore` list holds gitignore-style rules relative to each watched folder; plx skips the files and folders they exclude.

## License

MIT
