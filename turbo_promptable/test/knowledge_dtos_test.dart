import 'package:test/test.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  group('Knowledge DTOs', () {
    group('CollectionDto', () {
      test('can be instantiated with basic properties', () {
        final collection = CollectionDto(
          metaData: MetaDataDto(name: 'Test Collection', description: 'A test collection'),
          items: [],
        );

        expect(collection.metaData?.name, 'Test Collection');
        expect(collection.metaData?.description, 'A test collection');
        expect(collection.items, isNotNull);
        expect(collection.items.isEmpty, true);
      });

      test('can be instantiated with items', () {
        final collection = CollectionDto(
          metaData: MetaDataDto(name: 'Test Collection', description: 'Test collection description'),
          items: ['Item 1', 'Item 2'],
        );

        expect(collection.items, isNotNull);
        expect(collection.items.length, 2);
        expect(collection.items[0], 'Item 1');
        expect(collection.items[1], 'Item 2');
      });

    });

    group('InstructionDto', () {
      test('can be instantiated with basic properties', () {
        final instruction = InstructionDto(
          metaData: MetaDataDto(name: 'Test Instruction', description: 'A test instruction'),
        );

        expect(instruction.metaData?.name, 'Test Instruction');
        expect(instruction.metaData?.description, 'A test instruction');
      });

    });

    group('WorkflowDto', () {
      test('can be instantiated with basic properties', () {
        final workflow = WorkflowDto(
          metaData: MetaDataDto(name: 'Test Workflow', description: 'A test workflow'),
          steps: [],
        );

        expect(workflow.metaData?.name, 'Test Workflow');
        expect(workflow.metaData?.description, 'A test workflow');
        expect(workflow.steps, isNotNull);
        expect(workflow.steps.isEmpty, true);
      });

      test('can be instantiated with steps', () {
        final step1 = WorkflowStep(
          metaData: MetaDataDto(name: 'Step 1', description: 'Step 1 description'),
          workflowStepType: WorkflowStepType.act,
        );
        final step2 = WorkflowStep(
          metaData: MetaDataDto(name: 'Step 2', description: 'Step 2 description'),
          workflowStepType: WorkflowStepType.act,
        );

        final workflow = WorkflowDto(
          metaData: MetaDataDto(name: 'Test Workflow', description: 'Test workflow description'),
          steps: [step1, step2],
        );

        expect(workflow.steps, isNotNull);
        expect(workflow.steps.length, 2);
      });

    });

    group('ReferenceDto', () {
      test('can be instantiated with basic properties', () {
        final reference = ReferenceDto(
          metaData: MetaDataDto(name: 'Test Reference', description: 'A test reference'),
        );

        expect(reference.metaData?.name, 'Test Reference');
        expect(reference.metaData?.description, 'A test reference');
      });

    });

    group('TemplateDto', () {
      test('can be instantiated with basic properties', () {
        final template = TemplateDto(
          metaData: MetaDataDto(name: 'Test Template', description: 'A test template'),
        );

        expect(template.metaData?.name, 'Test Template');
        expect(template.metaData?.description, 'A test template');
        expect(template.variables, isNull);
      });

      test('can be instantiated with variables', () {
        final template = TemplateDto(
          metaData: MetaDataDto(name: 'Test Template', description: 'Test template description'),
          variables: {'name': 'World'},
        );

        expect(template.variables, isNotNull);
        expect(template.variables!['name'], 'World');
      });

    });

    group('RawBoxDto', () {
      test('can be instantiated with basic properties', () {
        final raw = RawBoxDto(
          metaData: MetaDataDto(name: 'Test Raw', description: 'A test raw'),
        );

        expect(raw.metaData?.name, 'Test Raw');
        expect(raw.metaData?.description, 'A test raw');
      });

    });

    group('ActivityDto', () {
      test('can be instantiated with basic properties', () {
        final workflow = WorkflowDto(
          metaData: MetaDataDto(name: 'Test Workflow', description: 'Test workflow description'),
          steps: [],
        );
        final activity = ActivityDto(
          metaData: MetaDataDto(name: 'Test Activity', description: 'A test activity'),
          workflow: workflow,
          output: 'result',
        );

        expect(activity.metaData?.name, 'Test Activity');
        expect(activity.metaData?.description, 'A test activity');
      });

    });

    group('AgentDto', () {
      test('can be instantiated with basic properties', () {
        final role = RoleDto(
          metaData: MetaDataDto(name: 'Test Role', description: 'Test role description'),
          expertise: ExpertiseDto(
            metaData: MetaDataDto(name: 'Engineering Expertise', description: 'Engineering expertise description'),
            field: 'Engineering',
            specialization: 'Backend',
            experience: '5 years',
          ),
        );
        final agent = SubAgentDto(
          metaData: MetaDataDto(name: 'Test Agent', description: 'A test agent'),
          role: role,
        );

        expect(agent.metaData?.name, 'Test Agent');
        expect(agent.metaData?.description, 'A test agent');
        expect(agent.role, role);
      });

      test('can be instantiated with role', () {
        final role = RoleDto(
          metaData: MetaDataDto(name: 'Test Role', description: 'Test role description'),
          expertise: ExpertiseDto(
            metaData: MetaDataDto(name: 'Engineering Expertise', description: 'Engineering expertise description'),
            field: 'Engineering',
            specialization: 'Backend',
            experience: '5 years',
          ),
        );
        final agent = SubAgentDto(
          metaData: MetaDataDto(name: 'Test Agent', description: 'Test agent description'),
          role: role,
        );

        expect(agent.role, role);
      });

    });

    group('RepoDto', () {
      test('can be instantiated with basic properties', () {
        final repo = RepoDto(
          metaData: MetaDataDto(name: 'Test Repo', description: 'A test repo'),
        );

        expect(repo.metaData?.name, 'Test Repo');
        expect(repo.metaData?.description, 'A test repo');
      });

    });
  });
}
