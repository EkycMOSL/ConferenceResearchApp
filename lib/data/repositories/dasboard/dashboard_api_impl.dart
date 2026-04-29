

import 'package:conferance_application/domain/api_state.dart';
import 'package:conferance_application/domain/respository/dashboard_repository.dart';

import '../../../config/constant/apiendpoints.dart';
import '../base/base_api_repository.dart';

class DashboardApiImpl extends DashboardRepository{
  final BaseApi _api;
  DashboardApiImpl(this._api);

  @override
  Future<ApiDataState<dynamic>?> getDashboardData({required String clientCode}) {
    var data = {"ClientId": "$clientCode"};
    return _api.apiCall(url: ApiEndpoints.getAnalystSchedule, requestType: RequestType.POST,body:data,isToken: true);
  }

}