import 'dart:convert';

import 'package:dio/dio.dart';

class TigerTranslationsHttpClient {
  static const String baseDomain = 'https://tigertranslations.org';
  // maximum page size of the wordpress rest api
  static const int maxPerPage = 100;

  final Dio _client = Dio();

  Future<Response> get(Uri path, {ResponseType responseType = ResponseType.json}) {
    return _client.getUri(path, options: Options(responseType: responseType));
  }

  Uri api(String endpoint, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseDomain/wp-json/wp/v2/$endpoint').replace(
      queryParameters: query?.map((key, value) => MapEntry(key, value.toString()))
    );
  }

  /// requests a single page of a wordpress collection endpoint
  Future<List<Map<String, dynamic>>> getList(String endpoint, Map<String, dynamic> query) async {
    Response res = await get(api(endpoint, query));
    List data = res.data is List ? res.data : jsonDecode(res.data);
    return data.cast<Map<String, dynamic>>();
  }

  /// requests all pages of a wordpress collection endpoint
  Future<List<Map<String, dynamic>>> getAll(String endpoint, Map<String, dynamic> query) async {
    List<Map<String, dynamic>> elements = [];
    int totalPages = 1;
    for (int page = 1; page <= totalPages; page++) {
      Response res = await get(api(endpoint, {
        ...query,
        'per_page': maxPerPage,
        'page': page
      }));
      totalPages = int.tryParse(res.headers.value('x-wp-totalpages') ?? '') ?? 1;
      List data = res.data is List ? res.data : jsonDecode(res.data);
      elements.addAll(data.cast<Map<String, dynamic>>());
    }
    return elements;
  }
}
