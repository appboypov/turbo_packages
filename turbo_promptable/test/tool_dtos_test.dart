import 'package:test/test.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  group('Tool DTOs', () {
    group('ApiDto', () {
      test('can be instantiated with basic properties', () {
        final api = ApiDto(
          metaData: MetaDataDto(name: 'Test API', description: 'A test API'),
        );

        expect(api.metaData?.name, 'Test API');
        expect(api.metaData?.description, 'A test API');
      });
    });

    group('ScriptDto', () {
      test('can be instantiated with basic properties', () {
        final script = ScriptDto(
          metaData: MetaDataDto(name: 'Test Script', description: 'A test script'),
        );

        expect(script.metaData?.name, 'Test Script');
        expect(script.metaData?.description, 'A test script');
        expect(script.input, isNull);
        expect(script.output, isNull);
        expect(script.instructions, isNull);
      });

      test('can be instantiated with input and output', () {
        final script = ScriptDto<String, String>(
          metaData: MetaDataDto(name: 'Test Script', description: 'Test script description'),
          input: 'input data',
          output: 'output data',
        );

        expect(script.input, 'input data');
        expect(script.output, 'output data');
      });

      test('can be instantiated with instructions', () {
        final script = ScriptDto(
          metaData: MetaDataDto(name: 'Test Script', description: 'A test script'),
          instructions: 'Run with --verbose flag',
        );

        expect(script.instructions, 'Run with --verbose flag');
      });

      test('can be instantiated with all properties', () {
        final script = ScriptDto<String, Map<String, dynamic>>(
          metaData: MetaDataDto(name: 'Test Script', description: 'A test script'),
          input: 'input data',
          output: {'result': 'success'},
          instructions: 'Run with --verbose flag',
        );

        expect(script.metaData?.name, 'Test Script');
        expect(script.metaData?.description, 'A test script');
        expect(script.input, 'input data');
        expect(script.output, {'result': 'success'});
        expect(script.instructions, 'Run with --verbose flag');
      });
    });

    group('PersonaDto', () {
      test('can be instantiated with basic properties', () {
        final persona = PersonaDto(
          metaData: MetaDataDto(name: 'Test Persona', description: 'A test persona'),
        );

        expect(persona.metaData?.name, 'Test Persona');
        expect(persona.metaData?.description, 'A test persona');
        expect(persona.preferences, isNull);
        expect(persona.values, isNull);
      });

      test('can be instantiated with preferences', () {
        final persona = PersonaDto(
          metaData: MetaDataDto(name: 'Test Persona', description: 'Test persona description'),
          preferences: ['helpful', 'knowledgeable', 'concise'],
        );

        expect(persona.preferences, isNotNull);
        expect(persona.preferences!.length, 3);
        expect(persona.preferences![0], 'helpful');
        expect(persona.preferences![1], 'knowledgeable');
        expect(persona.preferences![2], 'concise');
      });

      test('can be instantiated with values', () {
        final persona = PersonaDto(
          metaData: MetaDataDto(name: 'Test Persona', description: 'Test persona description'),
          values: ['honesty', 'respect', 'accuracy'],
        );

        expect(persona.values, isNotNull);
        expect(persona.values!.length, 3);
        expect(persona.values![0], 'honesty');
        expect(persona.values![1], 'respect');
        expect(persona.values![2], 'accuracy');
      });

      test('can be instantiated with background and communication style', () {
        final persona = PersonaDto(
          metaData: MetaDataDto(name: 'Test Persona', description: 'Test persona description'),
          background: 'Software engineer with 10 years experience',
          communicationStyle: 'Direct and concise',
        );

        expect(persona.background, 'Software engineer with 10 years experience');
        expect(persona.communicationStyle, 'Direct and concise');
      });

      test('can be instantiated with all properties', () {
        final persona = PersonaDto(
          metaData: MetaDataDto(name: 'Test Persona', description: 'A helpful assistant'),
          preferences: ['patient', 'thorough'],
          values: ['accuracy', 'clarity'],
          achievements: ['Award winner', 'Published author'],
          resume: ['Company A', 'Company B'],
          background: 'Experienced developer',
          communicationStyle: 'Professional',
          nickname: 'Helper',
        );

        expect(persona.metaData?.name, 'Test Persona');
        expect(persona.metaData?.description, 'A helpful assistant');
        expect(persona.preferences, isNotNull);
        expect(persona.preferences!.length, 2);
        expect(persona.values, isNotNull);
        expect(persona.values!.length, 2);
        expect(persona.achievements, isNotNull);
        expect(persona.achievements!.length, 2);
        expect(persona.resume, isNotNull);
        expect(persona.resume!.length, 2);
        expect(persona.background, 'Experienced developer');
        expect(persona.communicationStyle, 'Professional');
        expect(persona.nickname, 'Helper');
      });
    });
  });
}
