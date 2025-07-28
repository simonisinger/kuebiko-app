import 'dart:io';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:image/image.dart';

import 'library.dart';

class LocalBook implements Book {

  LocalBook(this.name, this.library);

  @override
  String name;
  final LocalLibrary library;

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
  Future<Image?> cover() {
    // TODO: implement cover
    throw UnimplementedError();
  }

  @override
  void delete() {
    File('${library.path}/$name').deleteSync();
  }

  @override
  Future<KuebikoDownload> download(Formats format) {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  Future<Progress> getProgress() {
    // dont implement this to prevent doubled data saving
    throw UnimplementedError();
  }

  @override
  // not needed
  int get id => throw UnimplementedError();

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
    // dont implement this to prevent doubled data saving
    throw UnimplementedError();
  }
}