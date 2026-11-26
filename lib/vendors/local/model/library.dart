import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/exceptions/io/ebook_read.dart';
import 'package:epubx_kuebiko/epubx_kuebiko.dart' as epubx;
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
    List<Book> bookList = await books(BookSorting.name, SortingDirection.asc);
    for (Book book in bookList) {
      // removes the ebook file, metadata, progress and reader cache
      await book.delete();
    }
    Directory directory = Directory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
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


  Future<LocalBook> _storeEbook(
      String filename,
      BookMeta meta,
      Stream<List<int>> fileContent,
      int fileLength,
      StreamController<double> progress
  ) async {
    File? file;
    try {
      int id = int.parse(await storage.read(key: ebookMaxIdKey) ?? '0') + 1;
      LocalBook localBook = LocalBook(filename, this, id);
      file = File(await StorageService.service.generatePath(localBook));

      // write the file completely before registering it anywhere
      IOSink sink = file.openWrite();
      int writtenLength = 0;
      try {
        await for (List<int> chunk in fileContent) {
          sink.add(chunk);
          writtenLength += chunk.length;
          progress.add(writtenLength / fileLength * 100);
        }
        await sink.flush();
      } finally {
        await sink.close();
      }

      // only verify the written file is a readable epub, the meta was already
      // parsed from the source file by the caller
      try {
        await epubx.EpubReader.openBookStream(file.openRead(), await file.length());
      } catch (e) {
        throw EbookReadException();
      }

      await storage.write(key: ebookMaxIdKey, value: id.toString());
      Map<String, dynamic> ebookList = await _ebooksList;
      ebookList[id.toString()] = filename;
      await storage.write(key: ebookListKey, value: jsonEncode(ebookList));

      await storage.write(
          key: localBook.metadataKey,
          value: jsonEncode({
            'name': meta.name,
            'author': meta.author,
            'description': '',
            'series': null,
            'number_of_volume': meta.volNumber,
            'publisher': null,
            'language': meta.language,
            'genre': null,
            'tag': null,
            'age_rating': null,
            "release_date": meta.releaseDate.toString(),
            "type": null
          })
      );
      return localBook;
    } catch (e, stackTrace) {
      if (file != null && await file.exists()) {
        await file.delete();
      }
      progress.addError(e, stackTrace);
      rethrow;
    } finally {
      progress.close();
    }
  }

  @override
  KuebikoUpload upload(String filename, BookMeta meta, Stream<List<int>> fileContent, int fileLength) {
    StreamController<double> progress = StreamController<double>();
    Future<LocalBook> book = _storeEbook(filename, meta, fileContent, fileLength, progress);
    return KuebikoUpload(progress.stream, book);
  }
}