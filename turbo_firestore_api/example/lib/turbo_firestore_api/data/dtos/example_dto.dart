import 'package:turbo_firestore_api/abstracts/turbo_writeable.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbo_serializable/models/turbo_serializable_config.dart';

class ExampleDTO extends TurboWriteable {
  ExampleDTO({
    required this.thisIsAString,
    required this.thisIsANumber,
    required this.thisIsABoolean,
  }) : super(
          config: TurboSerializableConfig(
            toJson: (instance) {
              final self = instance as ExampleDTO;
              return {
                "thisIsAString": self.thisIsAString,
                "thisIsANumber": self.thisIsANumber,
                "thisIsABoolean": self.thisIsABoolean,
              };
            },
          ),
        );

  final String thisIsAString;
  final double thisIsANumber;
  final bool thisIsABoolean;

  @override
  TurboResponse<T>? validate<T>() {
    if (thisIsAString.isEmpty) {
      return TurboResponse.fail(
        error: Exception('String cannot be empty'),
        title: 'Validation Error',
        message: 'The string field must not be empty',
      );
    }
    if (thisIsANumber < 0) {
      return TurboResponse.fail(
        error: Exception('Number must be positive'),
        title: 'Validation Error',
        message: 'The number must be greater than or equal to 0',
      );
    }
    return null;
  }

  factory ExampleDTO.fromJson(Map<String, dynamic> json) => ExampleDTO(
        thisIsAString: json["thisIsAString"] as String,
        thisIsANumber: json["thisIsANumber"] as double,
        thisIsABoolean: json["thisIsABoolean"] as bool,
      );
}
