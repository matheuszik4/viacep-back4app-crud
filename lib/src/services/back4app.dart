import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viacep/src/services/back4app_dio_interceptor.dart';

class Back4App {
  final _dio = Dio();

  Dio get dio => _dio;

  Back4App() {
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = dotenv.get("BACK4APPBASEURL");
    _dio.interceptors.add(Back4AppDioInterceptor());
  }
}


