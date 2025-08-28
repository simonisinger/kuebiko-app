import 'dart:convert';
import 'dart:io';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/services/ebook/ebook.dart';
import '../../../cache/storage.dart';
import '../../../services/client.dart';
import '../../../services/storage/storage.dart';
import '../../../vendors/local/model/book.dart';

class LocalLibrary implements Library {
  LocalLibrary(this.name, this.path);

  @override
  String name;

  @override
  String path;

  String get ebookListKey => 'local.${ClientService.service.getCurrentLocalName()}.$name.ebooks';
  // get the latest ebook id
  String get ebookMaxIdKey => 'local.${ClientService.service.getCurrentLocalName()}.$name.maxId';

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
    await Directory(path).delete(recursive: true);
    await storage.delete(key: ebookListKey);
    await storage.delete(key: ebookMaxIdKey);
  }

  @override
  // wont be implemented
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

  Future<Map<String, dynamic>> get _ebooksList async => jsonDecode(await storage.read(key: ebookListKey) ?? '{}');


  Stream<double> _getUploadProgressStream(String filename, Stream<List<int>> fileContent, int fileLength) async* {
    int maxId = int.parse(await storage.read(key: ebookMaxIdKey) ?? '0');
    String path = await StorageService.service.generatePath(LocalBook(filename, this, maxId+1));
    File file = File(path);

    file.openWrite().addStream(fileContent);

    double onePercent = fileLength / 100;
    int writtenLength = 0;
    await for (List<int> chunk in fileContent) {
      writtenLength += chunk.length;
      yield writtenLength / onePercent;
    }
    return;
  }

  @override
  KuebikoUpload upload(String filename, BookMeta meta, Stream<List<int>> fileContent, int fileLength) {
    int maxId = 0;
    fileContent = fileContent.asBroadcastStream();
    Stream<double> progressStream = _getUploadProgressStream(filename, fileContent, fileLength);

    Future<LocalBook> book = storage.read(key: ebookMaxIdKey)
        .then((String? ebookMaxId) {
          maxId = int.parse(ebookMaxId ?? '0');
          return storage.write(key: ebookMaxIdKey, value: (++maxId).toString());
        })
        .then((_)  => _ebooksList)
        .then((Map<String, dynamic> ebookList) {
          ebookList[maxId.toString()] = filename;
          return storage.write(key: ebookListKey, value: jsonEncode(ebookList));
        })
        .then((_) async {
          LocalBook localBook = LocalBook(filename, this, maxId);
          BookMeta bookMeta = await EbookService.parseEpubMeta(
              filename,
              File(await StorageService.service.generatePath(localBook)).openRead(),
              fileLength
          );

          await storage.write(
              key: localBook.metadataKey,
              value: jsonEncode({
                'name': bookMeta.name,
                'author': bookMeta.author,
                'description': '',
                'series': null,
                'number_of_volume': bookMeta.volNumber,
                'publisher': null,
                'language': bookMeta.language,
                'genre': null,
                'tag': null,
                'age_rating': null,
                "release_date": bookMeta.releaseDate,
                "type": null
              })
          );
          return localBook;
        });

    return KuebikoUpload(progressStream, book);
  }
}