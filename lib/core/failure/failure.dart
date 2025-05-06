
/// A generic failure, carrying an error message.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Example concrete failures:
class ServerFailure extends Failure {
  const ServerFailure([super.msg = 'Server error']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.msg = 'Validation error']);
}
