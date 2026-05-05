import 'package:conferance_application/config/appConfigUtils/local_storage_key.dart';
import 'package:conferance_application/config/appConfigUtils/localstorage.dart';
import 'package:conferance_application/data/models/dashboard/dashboard_response_model.dart';
import 'package:conferance_application/domain/respository/dashboard_repository.dart';
import 'package:conferance_application/features/login_screen/cubit/login_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/api_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  final DashboardRepository dashboardRepository;

  LoginScreenCubit(this.dashboardRepository) : super(LoginScreenInitial());

  Future<void> getDashboardData({required String clientCode}) async {
    emit(LoginScreenLoading());
    try {
      final responseJson = await dashboardRepository.getDashboardData(clientCode: clientCode);
      if (responseJson is DataSuccess) {
        final responseModel = DashboardResponseModel.fromJson(
          Map<String, dynamic>.from(responseJson.data as Map),
        );
        if (responseModel.response && responseModel.data != null) {
          print("Login Client Code : " + clientCode);
          await LocalStorage.putString(LocalStorageKeyName.clientCode, clientCode);
          emit(AnalystScheduleSuccess(responseModel));
        } else {
          emit(LoginScreenError(responseModel.message.isNotEmpty ? responseModel.message : 'No data found'));
        }
      } else {
        emit(LoginScreenError(responseJson?.errorMessage ?? 'Something went wrong'));
      }
    } catch (e) {
      emit(LoginScreenError(e.toString()));
    }
  }
}