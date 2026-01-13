import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../models/base_view_model_implementation.dart';

class HasErrorFeature extends UnitFeature {
  HasErrorFeature()
      : super(
          description: 'TurboViewModel.isError',
          scenarios: [
            UnitScenario<BaseViewModelImplementation, UnitExample>(
              description: 'Setting error status on the TurboViewModel',
              systemUnderTest: (mocks) =>
                  BaseViewModelImplementation(isMock: true),
              steps: [
                Given(
                  'The TurboViewModel has no error',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.hasError.value, false);
                    log.success('TurboViewModel did not have an error');
                  },
                ),
                When(
                  'we call the setError method with true',
                  (systemUnderTest, log, box, mocks, [example]) {
                    systemUnderTest.setError(true);
                  },
                ),
                Then(
                  'the TurboViewModel should have an error',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.hasError.value, true);
                    log.success('Error status was true!');
                  },
                ),
                When(
                  'we call the setError method with false',
                  (systemUnderTest, log, box, mocks, [example]) async {
                    systemUnderTest.setError(false);
                  },
                ),
                Then(
                  'the TurboViewModel should no longer have an error',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.hasError.value, false);
                    log.success('TurboViewModel did not have an error!');
                  },
                )
              ],
            )
          ],
        );
}
