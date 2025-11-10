class AppError {
  final String code;
  final String message;
  const AppError(this.code, this.message);
}

class Result<T> {
  final T? data;
  final AppError? error;
  const Result.ok(this.data) : error = null;
  const Result.err(this.error) : data = null;
  bool get isOk => error == null;
}