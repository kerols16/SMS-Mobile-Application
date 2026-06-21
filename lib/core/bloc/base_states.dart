import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();
  @override
  List<Object?> get props => [];
}

class BaseLoading extends BaseState {
  const BaseLoading();
}

class BaseOperationLoading extends BaseState {
  const BaseOperationLoading();
}

class BaseOperationSuccess extends BaseState {
  final String message;
  const BaseOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class BaseOperationError extends BaseState {
  final String message;
  const BaseOperationError(this.message);
  @override
  List<Object?> get props => [message];
}

class BaseError extends BaseState {
  final String message;
  const BaseError(this.message);
  @override
  List<Object?> get props => [message];
}