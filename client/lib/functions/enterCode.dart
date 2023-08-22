import 'dart:convert';
import 'package:http/http.dart';

class EnterCode {
  static Future<Response> enterCodeReq(String code) async {
    var data = jsonEncode({'code': code});

    Response response = await post(Uri.http('192.168.0.5:8000', 'enterCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: data);

    return response;
  }
}
