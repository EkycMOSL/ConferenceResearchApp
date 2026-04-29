import 'package:equatable/equatable.dart';

abstract class LoginScreenState extends Equatable {
  const LoginScreenState();

  @override
  List<Object?> get props => [];
}

class LoginScreenInitial extends LoginScreenState {}

class LoginScreenLoading extends LoginScreenState {}

class LoginScreenError extends LoginScreenState {
  final String message;

  const LoginScreenError(this.message);

  @override
  List<Object?> get props => [message];
}

class AnalystScheduleSuccess extends LoginScreenState {
  final String message;
  const AnalystScheduleSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

