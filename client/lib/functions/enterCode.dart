import 'dart:convert';
import 'package:client/config.dart';
import 'package:http/http.dart';

class EnterCode {
  static Future<Response> enterCodeReq(String code) async {
    var data = jsonEncode({'code': code});

    Response response = await post(Uri.http(BASE_IP, 'enterCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: data);

    return response;
  }
}
