import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: "http://192.168.8.101:3000/",
            connectTimeout: const Duration(seconds: 5000),
            receiveTimeout: const Duration(seconds: 3000),
            headers: {'Accept': 'application/json'},
          ),
        );

  Dio get dio => _dio;
}
