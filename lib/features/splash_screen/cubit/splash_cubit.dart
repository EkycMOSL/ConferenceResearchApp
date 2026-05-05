import 'package:conferance_application/config/appConfigUtils/local_storage_key.dart';
import 'package:conferance_application/config/appConfigUtils/localstorage.dart';
import 'package:conferance_application/data/models/dashboard/dashboard_response_model.dart';
import 'package:conferance_application/domain/api_state.dart';
import 'package:conferance_application/domain/respository/dashboard_repository.dart';
import 'package:conferance_application/utils/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final DashboardRepository _repository = locator<DashboardRepository>();

  SplashCubit() : super(const SplashInitial());

  Future<void> startSplashTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    if (isClosed) return;

    final clientCode = LocalStorage.getString(LocalStorageKeyName.clientCode);
    print("clientCode : $clientCode");
    if (clientCode.isEmpty) {
      emit(const SplashNavigateToLogin());
      return;
    }

    try {
      final result = await _repository.getDashboardData(clientCode: clientCode);
      if (isClosed) return;
      if (result is DataSuccess) {
        final responseModel = DashboardResponseModel.fromJson(
          Map<String, dynamic>.from(result.data as Map),
        );
        if (responseModel.response && responseModel.data != null) {
          emit(SplashNavigateToDashboard(responseModel: responseModel, clientCode: clientCode));
          return;
        }
      }
    } catch (_) {}

    emit(const SplashNavigateToLogin());
  }
}
