import 'package:conferance_application/features/login_screen/cubit/login_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreenCubit extends Cubit<LoginScreenState>
{
  LoginScreenCubit():super(LoginScreenInitial());
}
