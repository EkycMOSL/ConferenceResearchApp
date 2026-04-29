import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  void startSplashTimer() {
    Future.delayed(const Duration(seconds: 6), () {
      if (!isClosed) emit(const SplashNavigateToLogin());
    });
  }
}
