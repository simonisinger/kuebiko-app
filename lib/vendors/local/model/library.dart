import 'dart:io';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/vendors/local/model/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class LocalLibrary implements Library {
  LocalLibrary(this.name, this.path);

  @override
  String name;

  @override
  String path;

  @override
  Future<List<Book>> books(BookSorting sorting, SortingDirection direction) {
    // TODO: implement books
    throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  void renewMetadata() {
    // TODO: implement renewMetadata
  }

  @override
  void scan() {
    // TODO: implement scan
  }

  @override
  Future<List<Series>> series() {
    // TODO: implement series
    throw UnimplementedError();
  }

  @override
  void update() {
    // TODO: implement update
  }

  @override
  Future<Book> upload(String filename, BookMeta meta, Stream<List<int>> fileContent, int fileLength) async {
    Directory baseDirectory = await getApplicationDocumentsDirectory();
    Directory localEbooksDirectory = Directory(
        '${baseDirectory.path}${p.separator}localClients${p.separator}$name'
    );
    bool fileExists = localEbooksDirectory
        .listSync()
        .any((element) => p.basename(element.path) == filename);

    if (fileExists) {
      throw Exception('ebook already exists');
    }

    IOSink sink = File(localEbooksDirectory.path + p.separator + filename).openWrite()
      ..addStream(fileContent);
    await sink.done;

    return LocalBook(filename);
  }
}