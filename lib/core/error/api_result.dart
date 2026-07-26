import '../errors/failure.dart';

sealed class Result<T> {
  const Result();

  /// Creates a success result.
  factory Result.success(T data) = Success<T>;

  /// Creates a failure result.
  factory Result.failure(Failure failure) = Fail<T>;

  /// Returns true if this is a success result.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result.
  bool get isFailure => this is Fail<T>;

  /// Fold: handle both success and failure cases.
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    return switch (this) {
      Success<T>(data: final data) => onSuccess(data),
      Fail<T>(failure: final failure) => onFailure(failure),
    };
  }
}

/// Represents a successful result containing [data].
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Represents a failed result containing a [Failure].
class Fail<T> extends Result<T> {
  final Failure failure;
  const Fail(this.failure);
}
