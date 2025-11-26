abstract class Failure {
  final String message;

  const Failure({this.message = 'Unknown error'});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}
