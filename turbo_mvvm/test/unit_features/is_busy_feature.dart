import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../models/base_view_model_implementation.dart';

class IsBusyFeature extends UnitFeature {
  IsBusyFeature()
      : super(
          description: 'TurboViewModel.isInitialised',
          scenarios: [
            UnitScenario<BaseViewModelImplementation, UnitExample>(
              description: 'Setting busy status on the TurboViewModel',
              systemUnderTest: (mocks) =>
                  BaseViewModelImplementation(isMock: true),
              steps: [
                Given(
                  'The TurboViewModel is not busy',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isBusy.value, false);
                    log.success('TurboViewModel was not busy');
                  },
                ),
                When(
                  'we call the setBusy method with true',
                  (systemUnderTest, log, box, mocks, [example]) {
                    systemUnderTest.setBusy(true);
                  },
                ),
                Then(
                  'the TurboViewModel should be busy',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isBusy.value, true);
                    log.success('Boolean status was busy!');
                  },
                ),
                When(
                  'we call the setBusy method with false',
                  (systemUnderTest, log, box, mocks, [example]) async {
                    systemUnderTest.setBusy(false);
                  },
                ),
                Then(
                  'the TurboViewModel should no longer be busy',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isBusy.value, false);
                    log.success('TurboViewModel was not busy!');
                  },
                )
              ],
            )
          ],
        );
}
