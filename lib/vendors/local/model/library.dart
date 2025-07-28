import 'dart:convert';
import 'dart:io';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/cache/storage.dart';
import 'package:kuebiko_web_client/vendors/local/model/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class LocalLibrary implements Library {
  LocalLibrary(this.name, this.path);

  @override
  String name;

  @override
  String path;

  String get ebookListKey => 'local.$name.ebooks';

  @override
  Future<List<Book>> books(BookSorting sorting, SortingDirection direction) async {
    return (await _ebooksList).map((filename) => LocalBook(filename, this))
        .toList()
        ..sort((LocalBook a, LocalBook b) {
          if (direction == SortingDirection.desc) {
            return a.name.compareTo(b.name);
          } else {
            return b.name.compareTo(a.name);
          }
        });
  }

  @override
  Future<void> delete() async {
    (await _ebooksList).map((filename) => File(path).deleteSync(recursive: true));
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

  Future<Directory> getEbooksDirectory() async {
    Directory baseDirectory = await getApplicationDocumentsDirectory();
    return Directory(
        '${baseDirectory.path}${p.separator}localClients${p.separator}$name'
    );
  }

  Future<List<String>> get _ebooksList async => jsonDecode(await storage.read(key: ebookListKey) ?? '[]');

  @override
  Future<Book> upload(String filename, BookMeta meta, Stream<List<int>> fileContent, int fileLength) async {
    Directory localEbooksDirectory = await getEbooksDirectory();
    bool fileExists = localEbooksDirectory
        .listSync()
        .any((element) => p.basename(element.path) == filename);

    if (fileExists) {
      throw Exception('ebook already exists');
    }

    IOSink sink = File(localEbooksDirectory.path + p.separator + filename).openWrite()
      ..addStream(fileContent);
    await sink.done;

    List<String> ebookList = (await _ebooksList)..add(filename);
    storage.write(key: ebookListKey, value: jsonEncode(ebookList));

    return LocalBook(filename, this);
  }
}