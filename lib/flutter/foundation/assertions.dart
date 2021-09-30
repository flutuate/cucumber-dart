class FlutterError extends Error implements AssertionError {
  final String _message;
  FlutterError(this._message);

  @override
  String get message => _message;
}