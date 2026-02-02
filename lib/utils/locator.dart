import 'package:conferance_application/data/repositories/base/base_api_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {


  final dio = Dio();
  locator.registerSingleton<Dio>(dio);

  locator.registerSingleton<BaseApi>(
    BaseApi(),
  );

 /* locator.registerSingleton<RegistrationApiRepo>(
    RegistrationApiImpl(locator<BaseApi>()),
  );*/

}