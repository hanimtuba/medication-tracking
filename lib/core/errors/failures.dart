abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String? message]) : super(message ?? 'Server error occurred');
}

class CacheFailure extends Failure {
  CacheFailure([String? message]) : super(message ?? 'Cache error occurred');
}

class NetworkFailure extends Failure {
  NetworkFailure([String? message]) : super(message ?? 'Network error occurred');
}

class ValidationFailure extends Failure {
  ValidationFailure([String? message]) : super(message ?? 'Validation error occurred');
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure([String? message]) : super(message ?? 'Unexpected error occurred');
}

