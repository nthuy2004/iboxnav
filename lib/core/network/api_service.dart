import 'package:dio/dio.dart';
import 'package:iboxnav/config/typedef.dart';
import 'package:iboxnav/controllers/auth/auth_controller.dart';
import 'package:iboxnav/core/exceptions/exceptions.dart';
import 'package:iboxnav/core/network/api_provider.dart';
import 'package:get/get.dart' as getx;

class ApiService {
  final ApiProvider _apiProvider;
  ApiService(this._apiProvider);

  Map<String, String> buildAuthorizationHeader(Authorization? auth) {
    if (auth == null) return {};
    switch (auth.authType) {
      case AuthorizationType.Basic:
        return {
          "Authorization": "Basic ${auth.token!}",
        };
      case AuthorizationType.Bearer:
        return {
          "Authorization": "Bearer ${auth.token!}",
        };
      case AuthorizationType.Auto:
        return {"Authorization": auth.token!};
      default:
        return {};
    }
  }

  Future<Response> baseRequest(
      {required String endpoint,
      JSON? query,
      JSON? body,
      String method = "get",
      Authorization? authorization,
      bool withAuth = true,
      Map<String, String>? headers,
      Duration? timeout}) async {
    try {
      Authorization? getAuth() {
        if (authorization != null) {
          return authorization;
        }
        if (withAuth) {
          return getx.Get.find<AuthController>().getAuth();
        }
        return Authorization.none();
      }

      var customHeaders = buildAuthorizationHeader(getAuth());
      if (headers != null) {
        customHeaders.addAll(headers);
      }
      return await _apiProvider.base(endpoint, method,
          headers: customHeaders, query: query, timeout: timeout);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        throw AuthorizationException();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ConnectionTimeoutException();
      }
      throw Exception(e.message);
    }
  }

  Future<Response> get(String endpoint,
      {JSON? query,
      JSON? body,
      Map<String, String>? headers,
      Authorization? authorization,
      bool withAuth = true,
      Duration? timeout}) async {
    return await baseRequest(
        endpoint: endpoint,
        authorization: authorization,
        headers: headers,
        query: query,
        withAuth: withAuth,
        body: body,
        timeout: timeout);
  }

  Future<Response> post(String endpoint,
      {JSON? query,
      JSON? body,
      Map<String, String>? headers,
      Authorization? authorization,
      bool withAuth = true}) async {
    return await baseRequest(
        endpoint: endpoint,
        authorization: authorization,
        query: query,
        headers: headers,
        body: body,
        method: "post");
  }
}

class Authorization {
  final AuthorizationType authType;
  final String? token;
  Authorization({this.authType = AuthorizationType.None, this.token});
  factory Authorization.none() => Authorization();
}

enum AuthorizationType { Basic, Bearer, Auto, None }
