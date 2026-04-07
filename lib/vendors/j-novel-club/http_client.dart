import 'dart:convert';

import 'package:dio/dio.dart';

import '../../cache/storage.dart';
import '../../services/client.dart';
import 'exceptions/invalid_credentials.dart';
import 'exceptions/missing_credentials.dart';
import 'model/client.dart';

class JNovelClubHttpClient {
  final Dio _client = Dio();
  late String token;
  late String _name;
  String get _emailKey => "j-novel-club.$_name.username";
  String get _passwordKey => "j-novel-club.$_name.password";

  static Future<JNovelClubClient> login(String email, String password, String localName) async {
    JNovelClubHttpClient httpClient = JNovelClubHttpClient();
    await httpClient._login(email, password);
    httpClient._name = localName;
    JNovelClubClient client = JNovelClubClient(httpClient);
    await ClientService.service.addClient(client, localName);

    await storage.write(key: httpClient._emailKey, value: email);
    await storage.write(key: httpClient._passwordKey, value: password);
    return client;
  }

  static JNovelClubHttpClient fromToken(String token, String localName) {
    JNovelClubHttpClient client = JNovelClubHttpClient();
    client._name = localName;
    client.token = token;
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
    if (response.statusCode != 201) {
      throw InvalidCredentialsException();
    }

    token = (response.data is Map ? response.data : jsonDecode(response.data))["id"];
  }

  Future<void> _errorCheck(Response response) async {
    switch (response.statusCode) {
      case 400:
      case 401:
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
      "Authorization": "Bearer $token"
    }
  );

  bool _validateStatus(int? status) {
    return (status ?? 500) < 500;
  }

  Future<Response> get(Uri path, {ResponseType responseType = ResponseType.json}) async {
    Response response = await _client.getUri(
        path,
        options: _options.copyWith(
          responseType: responseType,
          validateStatus: _validateStatus
        )
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