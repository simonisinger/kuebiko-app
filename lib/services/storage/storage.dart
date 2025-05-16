import 'dart:io';
import 'dart:typed_data';

import 'package:epubx/epubx.dart' as epubx;
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:path_provider/path_provider.dart';

import '../ebook/epub_reader.dart';

class StorageService {
  static final StorageService service = StorageService();
  Future<void> storeEbook(Book book, Uint8List data) async {
    String path = await _generatePath(book);
    File(path).writeAsBytesSync(data);
  }

  Future<String> _generatePath(Book book) async {
    Directory baseDirectory = await getApplicationDocumentsDirectory();
    String domain = ClientService.service.selectedClient!.getConfig().baseUrl.host;
    return baseDirectory.path + '/$domain-${book.id}.epub';
  }

  Future<bool> ebookIsDownloaded(Book book) async {
    String path = await _generatePath(book);
    File ebookFile = File(path);
    return ebookFile.existsSync();
  }

  Future<EpubReader> getEbookReader(Book book) async {
    Uint8List ebookData;
    String path = await _generatePath(book);
    File ebookFile = File(path);
    // if (await ebookIsDownloaded(book)) {
      // ebookData = ebookFile.readAsBytesSync();
    // } else {
      ebookData = await book.download(Formats.epub);
      ebookFile
        ..createSync()
        ..writeAsBytesSync(ebookData);
    // }

    return EpubReader(await epubx.EpubReader.readBook(ebookData));
  }
}