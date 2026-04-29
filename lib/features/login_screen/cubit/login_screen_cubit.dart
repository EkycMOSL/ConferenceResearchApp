import 'package:conferance_application/domain/respository/dashboard_repository.dart';
import 'package:conferance_application/features/login_screen/cubit/login_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/api_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState>
{
  LoginScreenCubit(this.dashboardRepository):super(LoginScreenInitial());
  late DashboardRepository dashboardRepository;

  getDashboardData({required String clientCode }) async
  {
    emit(LoginScreenLoading());
    final responseJson= await dashboardRepository.getDashboardData(clientCode: clientCode);
    if(responseJson is DataSuccess)
    {
      String response = responseJson.data;
      emit(AnalystScheduleSuccess(response));
    }
    else if (responseJson is DataFailed) {
      emit(LoginScreenError(responseJson?.errorMessage ?? ""));
    } else {
      emit(LoginScreenError(responseJson?.errorMessage ?? ""));
    }
  }

}
