import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

import '../http_client.dart';

class JNovelClubBook implements Book {

  final JNovelClubHttpClient _httpClient;

  @override
  final int id;

  @override
  String name;

  final String _coverUrl;

  JNovelClubBook(this.id, this.name, this._coverUrl, this._httpClient);

  @override
  Future<String> convert(Formats format) {
    // maybe later
    throw UnimplementedError();
  }

  @override
  Future<String> convertStatus(String convertId) {
    // look above
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> cover() async {
    Response res = await _httpClient.get(
      Uri.parse(_coverUrl),
      responseType: ResponseType.bytes
    );
    return res.data;
  }

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<KuebikoDownload> download(Formats format) {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  Future<Progress> getProgress() {
    // TODO: implement getProgress
    throw UnimplementedError();
  }

  @override
  Future<Map> metadata() {
    // TODO: implement metadata
    throw UnimplementedError();
  }

  @override
  void renewMetadata() {
    // TODO: implement renewMetadata
  }

  @override
  Future<void> setProgress(Progress progress) {
    // TODO: implement setProgress
    throw UnimplementedError();
  }
}