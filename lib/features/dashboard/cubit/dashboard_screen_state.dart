import 'package:equatable/equatable.dart';

abstract class DashboardScreenState extends Equatable {
  const DashboardScreenState();

  @override
  List<Object?> get props => [];
}

class DashboardScreenInitial extends DashboardScreenState {}

class DashboardScreenLoading extends DashboardScreenState {}

class DashboardScreenError extends DashboardScreenState {
  final String message;

  const DashboardScreenError(this.message);

  @override
  List<Object?> get props => [message];
}
