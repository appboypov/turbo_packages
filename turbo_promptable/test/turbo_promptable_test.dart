import 'package:test/test.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

class TestPromptable extends TurboPromptable {
  TestPromptable({
    super.metaData,
  });
}

void main() {
  group('TurboPromptable', () {
    test('can be instantiated with name and description via MetaDataDto', () {
      final promptable = TestPromptable(
        metaData: MetaDataDto(
          name: 'Test Name',
          description: 'Test Description',
        ),
      );

      expect(promptable.metaData?.name, 'Test Name');
      expect(promptable.metaData?.description, 'Test Description');
      expect(promptable.shouldExport, true);
    });

    test('can be instantiated with shouldExport', () {
      final promptable = TestPromptable(
        metaData: MetaDataDto(name: 'Test', description: 'Test description'),
      );

      expect(promptable.shouldExport, true);
    });


    group('toXml', () {
      test('generates XML when metaDataDto exists', () {
        final promptable = TestPromptable(
          metaData: MetaDataDto(name: 'Test Name', description: 'Test Description'),
        );
        final xml = promptable.toXml();

        expect(xml, isNotNull);
        expect(xml, isNotEmpty);
      });

      test('excludes null fields from MetaDataDto in JSON serialization', () {
        final dtoWithNulls = MetaDataDto(name: 'Test Name', description: null);
        final json = dtoWithNulls.toJson();

        expect(json.containsKey('name'), true);
        expect(json.containsKey('description'), false);
        expect(json['name'], 'Test Name');

        final dtoOnlyDescription = MetaDataDto(name: null, description: 'Test Description');
        final json2 = dtoOnlyDescription.toJson();

        expect(json2.containsKey('name'), false);
        expect(json2.containsKey('description'), true);
        expect(json2['description'], 'Test Description');
      });
    });

    group('toXml', () {
      test('generates XML output', () {
        final promptable = TestPromptable(
          metaData: MetaDataDto(name: 'Test', description: 'Test description'),
        );

        final xml = promptable.toXml();
        expect(xml, isNotNull);
        expect(xml, isNotEmpty);
      });
    });
  });
}
