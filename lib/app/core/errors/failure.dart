abstract class IFailure implements Exception {
  final String? errorMessage;

  IFailure({
    StackTrace? stackTrace,
    dynamic exception,
    required this.errorMessage,
  });
}

class Failure extends IFailure {
  @override
  String errorMessage;
  dynamic exception;
  StackTrace? stackTrace;
  Failure({this.errorMessage = 'Unkwon message', this.stackTrace, this.exception})
      : super(errorMessage: errorMessage, stackTrace: stackTrace, exception: exception);
}
