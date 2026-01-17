// ignore_for_file: avoid_print
import 'package:turbo_response/turbo_response.dart';

/// Simulates a network call that can succeed or fail
Future<TurboResponse<String>> simulateNetworkCall(bool shouldSucceed) async {
  await Future.delayed(const Duration(seconds: 1));
  if (shouldSucceed) {
    return const TurboResponse.success(
      result: 'Operation completed successfully!',
      title: 'Success',
      message: 'The network call was successful',
    );
  } else {
    return const TurboResponse.fail(
      error: 'Network error occurred',
      title: 'Error',
      message: 'The network call failed',
    );
  }
}

/// Demonstrates pattern matching with when
void demonstratePatternMatching(TurboResponse<String> response) {
  print('\n--- Pattern Matching with when() ---');
  final message = response.when(
    success: (success) => '✓ ${success.title ?? "Success"}: ${success.result}',
    fail: (fail) => '✗ ${fail.title ?? "Error"}: ${fail.error}',
  );
  print(message);
  if (response.message != null) {
    print('  Message: ${response.message}');
  }
}

/// Demonstrates async operations
Future<void> demonstrateAsyncOperations() async {
  print('\n--- Async Operations ---');

  // Simulate a successful operation
  print('Simulating successful network call...');
  final successResponse = await simulateNetworkCall(true);
  demonstratePatternMatching(successResponse);

  // Transform the result
  print('\nTransforming success result...');
  final lengthResponse = await successResponse.mapSuccess(
    (value) => value.length,
  );
  print('Result length: ${lengthResponse.result}');

  // Chain operations
  print('\nChaining operations...');
  final chained = await successResponse.andThen((value) async => TurboResponse<int>.success(
        result: value.length,
        title: 'Length',
      ));
  print('Chained result: ${chained.result}');
}

/// Demonstrates utility methods
void demonstrateUtilityMethods() {
  print('\n--- Utility Methods ---');

  // unwrapOr
  final failResponse = const TurboResponse<String>.fail(
    error: 'Something went wrong',
    title: 'Error',
  );
  final value = failResponse.unwrapOr('default value');
  print('unwrapOr on fail: $value');

  // ensure
  final successResponse = const TurboResponse<int>.success(
    result: 42,
    title: 'Number',
  );
  final validated = successResponse.ensure(
    (value) => value > 0,
    error: 'Value must be positive',
  );
  print('ensure validation: ${validated.isSuccess ? "passed" : "failed"}');

  // unwrap
  try {
    final unwrapped = successResponse.unwrap();
    print('unwrap on success: $unwrapped');
  } catch (e) {
    print('unwrap threw: $e');
  }

  // throwWhenFail
  try {
    failResponse.throwWhenFail();
  } catch (e) {
    print('throwWhenFail caught: ${e.runtimeType}');
  }
}

/// Demonstrates empty constructors
void demonstrateEmptyConstructors() {
  print('\n--- Empty Constructors ---');

  final emptySuccess = const TurboResponse.successAsBool(
    title: 'Operation Complete',
    message: 'The operation completed successfully',
  );
  print('Empty success: ${emptySuccess.isSuccess}');
  print('  Title: ${emptySuccess.title}');
  print('  Message: ${emptySuccess.message}');

  final emptyFail = const TurboResponse.failAsBool(
    title: 'Operation Failed',
    message: 'The operation could not be completed',
  );
  print('Empty fail: ${emptyFail.isFail}');
  print('  Title: ${emptyFail.title}');
  print('  Message: ${emptyFail.message}');
}

/// Demonstrates static utility methods
Future<void> demonstrateStaticUtilities() async {
  print('\n--- Static Utility Methods ---');

  // traverse
  final items = ['apple', 'banana', 'cherry'];
  print('Processing items: $items');
  final traverseResult = await TurboResponseX.traverse(
    items,
    (item) async => TurboResponse<String>.success(
      result: item.toUpperCase(),
      title: 'Processed',
    ),
  );

  if (traverseResult.isSuccess) {
    print('Traverse result: ${traverseResult.result}');
  }

  // sequence
  final responses = [
    const TurboResponse<int>.success(result: 1, title: 'First'),
    const TurboResponse<int>.success(result: 2, title: 'Second'),
    const TurboResponse<int>.success(result: 3, title: 'Third'),
  ];
  final sequenceResult = TurboResponseX.sequence(responses);
  if (sequenceResult.isSuccess) {
    print('Sequence result: ${sequenceResult.result}');
  }

  // sequence with failure
  final mixedResponses = [
    const TurboResponse<int>.success(result: 1),
    const TurboResponse<int>.fail(error: 'Failed on second'),
    const TurboResponse<int>.success(result: 3),
  ];
  final failedSequence = TurboResponseX.sequence(mixedResponses);
  if (failedSequence.isFail) {
    print('Sequence with failure: ${failedSequence.error}');
  }
}

/// Demonstrates recovery and transformation
Future<void> demonstrateRecovery() async {
  print('\n--- Recovery and Transformation ---');

  final failResponse = const TurboResponse<String>.fail(
    error: 'Network timeout',
    title: 'Connection Error',
    message: 'The request timed out',
  );

  // Recover from failure
  final recovered = await failResponse.recover(
    (error) => 'Recovered value from: $error',
  );
  print('Recovered result: ${recovered.result}');
  print('  Preserved title: ${recovered.title}');

  // Map fail
  final mappedFail = await failResponse.mapFail(
    (error) => 'Wrapped: $error',
  );
  print('Mapped fail error: ${mappedFail.error}');
}

void main() async {
  print('=== TurboResponse Demo ===\n');
  print('This example demonstrates the key features of TurboResponse:');
  print('- Pattern matching with when()');
  print('- Async operations and chaining');
  print('- Utility methods (unwrap, unwrapOr, ensure)');
  print('- Empty constructors');
  print('- Static utilities (traverse, sequence)');
  print('- Recovery and transformation');

  // Demonstrate basic pattern matching
  const successExample = TurboResponse<String>.success(
    result: 'Hello, World!',
    title: 'Greeting',
    message: 'A friendly greeting',
  );
  demonstratePatternMatching(successExample);

  const failExample = TurboResponse<String>.fail(
    error: 'Something went wrong',
    title: 'Error',
    message: 'An error occurred',
  );
  demonstratePatternMatching(failExample);

  // Demonstrate async operations
  await demonstrateAsyncOperations();

  // Demonstrate utility methods
  demonstrateUtilityMethods();

  // Demonstrate empty constructors
  demonstrateEmptyConstructors();

  // Demonstrate static utilities
  await demonstrateStaticUtilities();

  // Demonstrate recovery
  await demonstrateRecovery();

  print('\n=== Demo Complete ===');
}
