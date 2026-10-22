/// The HTTP method of a Request to TypeSafe.
enum TJevHttpMethod {
  /// Sends a body, such as the Questions of a System One Request.
  post('POST'),

  /// Reads without a body, such as the models list.
  get('GET');

  const TJevHttpMethod(this.wireValue);

  /// The name of the method on the wire.
  final String wireValue;
}
