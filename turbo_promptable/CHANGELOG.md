# Changelog

## 0.0.1

- Initial release
- TurboPromptable base class extending TurboSerializable
- Convenience `name` and `description` constructor parameters on all DTOs
- Automatic FrontmatterDto creation from name/description
- ExportConfig with fileType, bodyType, shouldExport, fileName
- ExportType enum (md, yaml, json, xml, txt, dart)
- BodyType enum (markdown, yaml, json, xml, dart)
- Tree structure with config inheritance via resolveConfig
- YAML frontmatter generation via generateFrontmatter
- Body export via exportBody
- FrontmatterDto for structured metadata (name, description, values)
- ExportResult for export output (body, frontmatter, config, promptable)
- export() method with shouldExport filtering
- exportTree() method for recursive tree export
- Hierarchy DTOs: TeamDto, AreaDto, RoleDto
- Knowledge DTOs: CollectionDto, InstructionDto, WorkflowDto, ReferenceDto, TemplateDto, RawBoxDto, ActivityDto, AgentDto, RepoDto
- Tool DTOs: ToolDto, ApiDto, ScriptDto, ToolMethodDto, ToolParameterDto
- PersonaDto for agent identity
