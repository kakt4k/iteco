import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerSingleton(Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000')));
}