/// Validator callback for multi-value form fields.
///
/// Returns an error message string if validation fails, or `null` if valid.
typedef ValuesValidatorDef<T> = String? Function(List<T>? values);
