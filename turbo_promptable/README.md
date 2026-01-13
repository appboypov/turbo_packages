# turbo_promptable

Object-Oriented Prompting framework for the turbo ecosystem. Define AI agent prompts, roles, workflows, and tools as type-safe Dart objects.

## Features

- TurboPromptable base class extending TurboSerializable
- FrontmatterDto for structured metadata with custom values
- ExportResult for export output
- export() for single promptable export
- 18 DTOs for organizational hierarchy (Team, Area, Role)
- Knowledge DTOs (Collection, Instruction, Workflow, Reference, Template, RawBox, Activity, SubAgent, Repo)
- Tool DTOs (API, Script) with method and parameter definitions
- PersonaDto for agent identity
- YAML frontmatter generation
- Config inheritance across tree levels

## Installation

```yaml
dependencies:
  turbo_promptable: ^0.0.1
```

## Usage

```dart
import 'package:turbo_promptable/turbo_promptable.dart';

// Create a team structure using convenience parameters
final team = TeamDto(
  name: 'Engineering',
  description: 'Engineering team',
  body: (_) => 'Engineering team content',
  areas: [
    AreaDto(
      name: 'Backend',
      description: 'Backend area',
      body: (_) => 'Backend area content',
      roles: [
        RoleDto(
          name: 'API Developer',
          description: 'API Developer role',
          body: (_) => 'API Developer role content',
          expertise: ExpertiseDto(
            name: 'Backend Expertise',
            description: 'Backend development expertise',
            field: 'Backend',
            specialization: 'API Development',
            experience: '5 years',
            body: (_) => 'Expertise content',
          ),
        ),
      ],
    ),
  ],
);

// Generate frontmatter
final frontmatter = team.exportMetaData();
// ---
// name: Engineering
// description: Engineering team
// ---

// Export single promptable
final result = team.export(null);
print(result?.value);
```

## FrontmatterDto

All DTOs accept `name` and `description` as convenience parameters. Use `metaData` for custom values or to override:

```dart
// Simple usage - name and description only
final instruction = InstructionDto(
  name: 'Code Review',
  description: 'How to review code',
  body: (_) => 'Review code thoroughly...',
);

// With custom values via metaData
final instruction = InstructionDto(
  name: 'Code Review',
  description: 'How to review code',
  metaData: {'priority': 'high', 'category': 'process'},
  body: (_) => 'Review code thoroughly...',
);
// Result: name='Code Review', description='How to review code', priority='high', category='process'

// metaData overrides name/description when both are provided
final instruction = InstructionDto(
  name: 'Code Review',           // ignored
  metaData: {
    'name': 'PR Review',           // takes precedence
    'description': 'How to review PRs',
    'priority': 'high',
  },
  body: (_) => 'Review code thoroughly...',
);
// Result: name='PR Review', description='How to review PRs', priority='high'

// Generate frontmatter includes custom values
final frontmatter = instruction.generateFrontmatter();
// ---
// name: PR Review
// description: How to review PRs
// priority: high
// ---
```

## Export Configuration

Control how promptables are exported with `ExportConfig`:

```dart
final role = RoleDto(
  name: 'Developer',
  description: 'Developer role',
  body: (_) => 'Developer role content',
  expertise: ExpertiseDto(
    name: 'Development Expertise',
    description: 'Development expertise',
    field: 'Software',
    specialization: 'Full Stack',
    experience: '3 years',
    body: (_) => 'Expertise content',
  ),
  exportConfig: const ExportConfig(
    shouldExport: true,
    fileExtension: 'md',
    bodyType: BodyType.markdown,
    path: '.',
    fileName: 'developer-role',
  ),
);

// Export single promptable
final result = role.export(null);
print(result?.combined); // frontmatter + body

// Resolve config with parent inheritance
final resolved = role.resolveConfig(parentConfig);
```

## DTOs

### Hierarchy

- `TeamDto` - Top-level organizational unit containing areas
- `AreaDto` - Domain within a team containing roles
- `RoleDto` - Specialist role within an area containing knowledge items

### Knowledge

- `CollectionDto` - Lists of items
- `InstructionDto` - How-to guides and behavioral rules
- `WorkflowDto` - Step-by-step processes
- `ReferenceDto` - Static documentation with optional URL
- `TemplateDto` - Reusable patterns with variables
- `RawBoxDto` - Raw input materials
- `ActivityDto` - AI commands with prompt and model
- `SubAgentDto` - AI agents with role assignment
- `RepoDto` - Repository references with path and URL

### Tools

- `ApiDto` - HTTP/REST API tools
- `ScriptDto` - Executable script tools with input/output types

### Identity

- `PersonaDto` - Agent identity with traits, tone, and constraints

## License

MIT
