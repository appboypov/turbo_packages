import 'package:turbo_widgets/src/models/playground/t_playground_parameter.dart';

/// Container for multiple playground parameters.
///
/// Provides convenient accessors to retrieve parameters by ID and get their values.
class TPlaygroundParameters {
  /// Creates a parameters container from a list of parameters.
  TPlaygroundParameters({
    required List<TPlaygroundParameter<dynamic>> parameters,
  }) : parameters = List.unmodifiable(parameters);

  /// The list of all parameters.
  final List<TPlaygroundParameter<dynamic>> parameters;

  late final Map<String, TPlaygroundParameter<dynamic>> _byId = {
    for (final p in parameters) p.id: p,
  };

  /// Whether there are no parameters.
  bool get isEmpty => parameters.isEmpty;

  /// Whether there are any parameters.
  bool get isNotEmpty => parameters.isNotEmpty;

  /// Gets a parameter by its ID.
  ///
  /// Throws if the parameter is not found or has an incompatible type.
  TPlaygroundParameter<T> parameter<T>(String id) =>
      _byId[id]! as TPlaygroundParameter<T>;

  /// Gets the current value of a parameter by its ID.
  ///
  /// Throws if the parameter is not found or has an incompatible type.
  T value<T>(String id) => parameter<T>(id).value;

  /// Checks if a parameter with the given ID exists.
  bool contains(String id) => _byId.containsKey(id);
}
