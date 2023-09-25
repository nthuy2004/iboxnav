import 'dart:async';
import 'package:dio/dio.dart';
import 'package:iboxnav/config/constants.dart';
import 'package:iboxnav/config/typedef.dart';

class ApiProvider {
  final _dio = Dio();
  final _baseUrl = Constants.API_BASE_URL;
  Future<Response<String>> get(String url,
      {Map<String, String>? headers,
      JSON? body,
      JSON? query,
      bool withBaseUrl = true,
      Duration? timeout}) async {
    return base(url, "get",
        headers: headers,
        body: body,
        query: query,
        withBaseUrl: withBaseUrl,
        timeout: timeout);
  }

  Future<Response<String>> base(String url, String method,
      {Map<String, String>? headers,
      JSON? body,
      JSON? query,
      bool withBaseUrl = true,
      Duration? timeout}) {
    String finalUrl = withBaseUrl ? "$_baseUrl$url" : url;
    return _dio.request(finalUrl,
        queryParameters: query,
        options: Options(
            headers: headers,
            method: method,
            sendTimeout: timeout,
            receiveTimeout: timeout));
  }

  Future<Response<String>> post(String url,
      {Map<String, String>? headers,
      JSON? body,
      JSON? query,
      bool withBaseUrl = true,
      Duration? timeout}) async {
    return base(url, "post",
        headers: headers,
        body: body,
        query: query,
        withBaseUrl: withBaseUrl,
        timeout: timeout);
  }
}
