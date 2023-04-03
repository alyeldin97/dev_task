class Failure {
  int code;
  String message;
  Failure({
    required this.code,
    required this.message,
  });
}

class AppFailures {
  static Failure defaultFailure = Failure(
    code: 0,
    message: 'An UnExpected Error Occured',
  );

  static Failure socketFailure = Failure(
    code: 0,
    message: 'Please Check Your Internet Connection',
  );
}
