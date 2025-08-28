import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/cache/storage.dart';

import '../../../services/client.dart';

class LocalBook implements Book {
  LocalBook(this.name, this.library, this.id);

  String get metadataKey => 'local.${ClientService.service.getCurrentLocalName()}.${library.name}.$id';

  @override
  final int id;

  @override
  String name;
  final Library library;

  @override
  Future<String> convert(Formats format) {
    // no need at them moment
    throw UnimplementedError();
  }

  @override
  Future<String> convertStatus(String convertId) {
    // no need at the moment
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> cover() {
    // TODO: implement cover
    throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    return File('${library.path}/$name').delete();
  }

  @override
  Future<KuebikoDownload> download(Formats format) {
    // wont be implemented
    throw UnimplementedError();
  }

  @override
  Future<Progress> getProgress() {
    // dont implement this to prevent doubled data saving
    throw UnimplementedError();
  }

  @override
  Future<Map> metadata() async {
    String? data = await storage.read(key: metadataKey);
    if (data != null) {
      return jsonDecode(data);
    } else {
      return {
        'name': name,
        'author': 'Unknown Author',
        'description': '',
        'series': null,
        'number_of_volume': null,
        'publisher': null,
        'language': 'und',
        'genre': null,
        'tag': null,
        'age_rating': null,
        "release_date": null,
        "type": null
      };
    }
  }

  @override
  void renewMetadata() {
    // TODO: implement renewMetadata
  }

  @override
  Future<void> setProgress(Progress progress) {
    // dont implement this to prevent doubled data saving
    throw UnimplementedError();
  }
}