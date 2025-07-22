import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:image/image.dart';

class LocalBook implements Book {

  LocalBook(this.name);

  @override
  String name;

  @override
  Future<String> convert(Formats format) {
    // TODO: implement convert
    throw UnimplementedError();
  }

  @override
  Future<String> convertStatus(String convertId) {
    // TODO: implement convertStatus
    throw UnimplementedError();
  }

  @override
  Future<Image?> cover() {
    // TODO: implement cover
    throw UnimplementedError();
  }

  @override
  void delete() {
    // TODO: implement delete
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
  // TODO: implement id
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