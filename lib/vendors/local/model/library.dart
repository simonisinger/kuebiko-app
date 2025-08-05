import 'dart:convert';
import 'dart:io';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/cache/storage.dart';
import 'package:kuebiko_web_client/services/client.dart';
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
  // get the latest ebook id
  String get ebookMaxIdKey => 'local.$name.maxId';

  @override
  Future<List<Book>> books(BookSorting sorting, SortingDirection direction) async {
    return (await _ebooksList).map((id,filename) => MapEntry(id, LocalBook(filename, this, int.parse(id))))
        .values
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
    (await _ebooksList).forEach((_,filename) => File(path).deleteSync(recursive: true));
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
        '${baseDirectory.path}${p.separator}${ClientService.service.getCurrentLocalName()}${p.separator}$name'
    );
  }

  Future<Map<String, dynamic>> get _ebooksList async => jsonDecode(await storage.read(key: ebookListKey) ?? '{}');


  Stream<double> _getUploadProgressStream(String filename, Stream<List<int>> fileContent, int fileLength) async* {
    Directory localEbooksDirectory = await getEbooksDirectory();
    bool fileExists = localEbooksDirectory
        .listSync()
        .any((element) => p.basename(element.path) == filename);
    if (!fileExists) {
      fileContent = fileContent.asBroadcastStream();
      File(localEbooksDirectory.path + p.separator + filename).openWrite()
        .addStream(fileContent);

      double onePercent = fileLength / 100;
      int writtenLength = 0;
      await for (List<int> chunk in fileContent) {
        writtenLength += chunk.length;
        yield writtenLength / onePercent;
      }
    } else {
      return;
    }
  }

  @override
  KuebikoUpload upload(String filename, BookMeta meta, Stream<List<int>> fileContent, int fileLength) {
    int maxId = 0;
    Stream<double> progressStream = _getUploadProgressStream(filename, fileContent, fileLength);
    Future<LocalBook> book = getEbooksDirectory()
        .then((Directory localEbooksDirectory) {
          bool fileExists = localEbooksDirectory
            .listSync()
            .any((element) => p.basename(element.path) == filename);

          if (fileExists) {
            throw Exception('ebook already exists');
          }
          return storage.read(key: ebookMaxIdKey);
        })
        .then((String? ebookMaxId) {
          maxId = int.parse(ebookMaxId ?? '0');
          return storage.write(key: ebookMaxIdKey, value: (++maxId).toString());
        })
        .then((_)  => _ebooksList)
        .then((Map<String, dynamic> ebookList) {
          ebookList[maxId.toString()] = filename;
          return storage.write(key: ebookListKey, value: jsonEncode(ebookList));
        })
        .then((_) => LocalBook(filename, this, id));

    return KuebikoUpload(progressStream, book);
  }
}