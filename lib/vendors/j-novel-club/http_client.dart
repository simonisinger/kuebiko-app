import 'dart:convert';

import 'package:dio/dio.dart';
import '../../cache/storage.dart';
import '../../services/client.dart';
import 'exceptions/invalid_credentials.dart';
import 'exceptions/missing_credentials.dart';

class JNovelClubHttpClient {
  final Dio _client = Dio();
  late String _token;

  String get _emailKey => "j-novel-club.${ClientService.service.getCurrentLocalName()}.username";
  String get _passwordKey => "j-novel-club.${ClientService.service.getCurrentLocalName()}.password";

  static Future<JNovelClubHttpClient> login(String email, String password) async {
    JNovelClubHttpClient client = JNovelClubHttpClient();
    await client._login(email, password);

    return client;
  }

  static JNovelClubHttpClient fromToken(String token) {
    JNovelClubHttpClient client = JNovelClubHttpClient();
    client._token = token;
    return client;
  }

  Future<void> _login(String email, String password) async {
    Response response = await _client.post(
        'https://labs.j-novel.club/app/v2/auth/login?format=json',
        data: jsonEncode({
          "login": email,
          "password": password,
          "slim": true
        })
    );
    if (response.statusCode != 200) {
      throw InvalidCredentialsException();
    }

    _token = (response.data is Map ? response.data : jsonDecode(response.data))["id"];
  }

  Future<void> _errorCheck(Response response) async {
    switch (response.statusCode) {
      case 400:
        String? email = await storage.read(key: _emailKey);
        String? password = await storage.read(key: _passwordKey);
        if (email == null || password == null) {
          throw MissingCredentialsException();
        }
        await _login(email, password);
    }
  }

  Options get _options => Options(
    headers: {
      "labs_auth": _token
    }
  );

  Future<Response> get(Uri path) async {
    Response response = await _client.getUri(
        path,
        options: _options
    );
    await _errorCheck(response);

    return response;
  }

  Future<Response> post(Uri path, [String? body]) async {
    Response response = await _client.postUri(path, data: body);
    await _errorCheck(response);

    return response;
  }
}