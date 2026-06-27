import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_forms/turbo_forms.dart';

void main() {
  group('TFormFieldConfig.copyControllerValueFrom', () {
    test(
      'Given source controller text and empty source value, when copied, then target has value',
      () {
        final source = TFormFieldConfig<String>(
          id: 'source',
          fieldType: TFieldType.textInput,
        );
        final target = TFormFieldConfig<String>(
          id: 'target',
          fieldType: TFieldType.textInput,
        );
        addTearDown(source.dispose);
        addTearDown(target.dispose);
        source.textEditingController!.text = 'a@b.com';

        expect(target.hasValue, isFalse);

        target.copyControllerValueFrom(source);

        expect(target.hasValue, isTrue);
      },
    );
  });
}
