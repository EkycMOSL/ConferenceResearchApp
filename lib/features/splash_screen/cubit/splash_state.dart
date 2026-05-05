import 'package:conferance_application/data/models/dashboard/dashboard_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashNavigateToLogin extends SplashState {
  const SplashNavigateToLogin();
}

class SplashNavigateToDashboard extends SplashState {
  final DashboardResponseModel responseModel;
  final String clientCode;

  const SplashNavigateToDashboard({required this.responseModel, required this.clientCode});

  @override
  List<Object?> get props => [responseModel, clientCode];
}
