
import 'package:conferance_application/domain/api_state.dart';

abstract class DashboardRepository {

  Future<ApiDataState<dynamic>?> getDashboardData({required String clientCode});

}