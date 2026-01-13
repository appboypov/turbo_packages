import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../models/base_view_model_implementation.dart';

class IsInitialisedFeature extends UnitFeature {
  IsInitialisedFeature()
      : super(
          description: 'TurboViewModel.isInitialised',
          scenarios: [
            UnitScenario<BaseViewModelImplementation, UnitExample>(
              description: 'Initialising the TurboViewModel',
              systemUnderTest: (mocks) =>
                  BaseViewModelImplementation(isMock: true),
              steps: [
                Given(
                  'The TurboViewModel is not initialised yet',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isInitialised.value, false);
                    log.success('TurboViewModel was not initialised!');
                  },
                ),
                When(
                  'we call the initialise method',
                  (systemUnderTest, log, box, mocks, [example]) async {
                    await systemUnderTest.initialise();
                  },
                ),
                Then(
                  'the TurboViewModel should be initialised',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isInitialised.value, true);
                    log.success('TurboViewModel was initialised!');
                  },
                )
              ],
            )
          ],
        );
}
