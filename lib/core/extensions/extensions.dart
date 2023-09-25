import 'package:dio/dio.dart';

extension ResponseX on Response {
  bool isOK() {
    if (statusCode == null) return false;
    return statusCode! >= 200 && statusCode! <= 299;
  }
}

extension StringX on String {
  String superTrim() {
    return replaceAll(RegExp(r"\s+"), "");
  }
}
