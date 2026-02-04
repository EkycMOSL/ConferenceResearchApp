import 'package:conferance_application/features/dashboard/cubit/dashboard_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreenCubit extends Cubit<DashboardScreenState>
{
  DashboardScreenCubit():super(DashboardScreenInitial());
}
