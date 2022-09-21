import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static var baseUrl =
      "https://kzo.qaznaonline.kz/kzo/hs/DDO/";
  static var client = http.Client();
  static var mRUrl = "http://157.245.107.107/";
  static var login = '${baseUrl}auth';

  Future<http.MultipartRequest> request(
      String url, String method, bool urlSlug) async {
    var _url = "${Api.baseUrl}$url";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(_url);
    var request = http.MultipartRequest(method, Uri.parse(_url));
    request.headers['Authorization'] = 'Bearer $token';

    return request;
  }

  Future<Map<String, dynamic>> getBody(response) async {
    var responseBody = await http.Response.fromStream(response);
    return json.decode(responseBody.body);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

}
