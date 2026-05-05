import 'package:conferance_application/config/appConfigUtils/localstorage.dart';
import 'package:conferance_application/data/repositories/base/base_api_repository.dart';
import 'package:conferance_application/data/repositories/dasboard/dashboard_api_impl.dart';
import 'package:conferance_application/domain/respository/dashboard_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  await LocalStorage.getInstance();

  final dio = Dio();
  locator.registerSingleton<Dio>(dio);

  locator.registerSingleton<BaseApi>(
    BaseApi(),
  );

  locator.registerSingleton<DashboardRepository>(
    DashboardApiImpl(locator<BaseApi>()),
  );

}