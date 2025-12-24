import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:epubx_kuebiko/epubx_kuebiko.dart' as epubx;
import 'package:file_picker/file_picker.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/exceptions/io/ebook_read.dart';
import 'package:kuebiko_web_client/vendors/local/model/book.dart';
import 'package:kuebiko_web_client/vendors/local/model/client.dart';
import '../../cache/storage.dart';
import '../../services/client.dart';
import '../../services/ebook/ebook.dart';
import 'package:path_provider/path_provider.dart';

import '../ebook/epub_reader.dart';

class StorageService {
  static final StorageService service = StorageService();

  String get librariesCacheKey => 'libraries.${ClientService.service.getCurrentLocalName()}';
  String get libraryEbookCacheKey => 'libraries.${ClientService.service.getCurrentLocalName()}.${ClientService.service.selectedLibrary!.name}.ebooks';
  String libraryEbookMetadataCacheKey(Book book) => 'libraries.${ClientService.service.getCurrentLocalName()}.${ClientService.service.selectedLibrary!.name}.${book.id}.metadata';

  Future<String> generatePath(Book book) async {
    Directory baseDirectory = await getApplicationDocumentsDirectory();
    String localName = ClientService.service.getCurrentLocalName()!;
    return '${baseDirectory.path}/$localName-${book.id}.epub';
  }

  Future<bool> ebookIsDownloaded(Book book) async {
    String path = await generatePath(book);
    File ebookFile = File(path);
    return ebookFile.existsSync();
  }

  Future<void> deleteEbook(Book book) async {
    File(await generatePath(book)).deleteSync();
  }

  Future<KuebikoUpload> uploadEbook(PlatformFile file) async {
    BookMeta? meta = await EbookService.parseEpubMeta(file.name, file.xFile.openRead(), file.size);
    if (meta == null) {
      throw EbookReadException();
    }
    return ClientService.service.selectedLibrary!.upload(
        file.name,
        meta,
        file.xFile.openRead(),
        file.size
    );
  }

  Future<void> writeEbookMetadataCache(Book book, Map<String, dynamic> metadata) async {
    if (ClientService.service.clientHasFeature(ClientFeature.ebookMetadataCache)) {
      await storage.write(
          key: libraryEbookMetadataCacheKey(book),
          value: jsonEncode(metadata)
      );
    }
  }

  Future<Map<String, dynamic>> readEbookMetadataCache(Book book) async {
    String? rawData = await storage.read(key:libraryEbookMetadataCacheKey(book));
    if (rawData == null) {
      throw Exception('no metadata cache for book with id ${book.id}');
    }
    return jsonDecode(rawData);
  }

  Future<List<Book>> readLibraryEbookCache() async {
    String? rawData = await storage.read(key: libraryEbookCacheKey);
    if (rawData == null) {
      throw Exception('no ebook cache for the library ${ClientService.service.selectedLibrary!.name}');
    }
    List listRaw = jsonDecode(rawData);

    return listRaw.map((rawBook) {
      switch(ClientService.service.selectedClient) {
        case KuebikoClient client:
          return KuebikoBook(
              rawBook['id'],
              ClientService.service.selectedLibrary!,
              rawBook['name'],
              client.cacheController,
              client.client
          );
        case LocalClient _:
          return LocalBook(rawBook['name'], ClientService.service.selectedLibrary!, rawBook['id']);
      }
      throw Exception('unsupported');
    }).toList();
  }

  Future<void> writeLibraryEbookCache(List<Book> books) async {
    if (ClientService.service.clientHasFeature(ClientFeature.ebooksCache)) {
      await storage.write(
          key: libraryEbookCacheKey,
          value: jsonEncode(
              books.map((book) => {
                'id': book.id,
                'name': book.name
              }).toList()
          )
      );
    }
  }

  Future<void> writeLibrariesCache(List<Library> libraries) async {
    if (ClientService.service.clientHasFeature(ClientFeature.librariesCache)) {
      await storage.write(
          key: librariesCacheKey,
          value: jsonEncode(
              libraries.map((library) => {
                'id': library.id,
                'name': library.name
              }).toList()
          )
      );
    }
  }

  Stream<double> downloadEbook(Book book) async* {
    String path = await generatePath(book);
    File ebookFile = File(path);
    if (!(await ebookIsDownloaded(book))) {
      final KuebikoDownload download = await book.download(Formats.epub);
      ebookFile.createSync();
      RandomAccessFile raFile = await ebookFile.open(mode: FileMode.writeOnlyAppend);
      int lengthCounter = 0;
      await for (List<int> data in download.stream) {
        await raFile.writeFrom(data);
        lengthCounter += data.length;
        yield lengthCounter / download.length;
      }
    } else {
      throw Exception('ebook already exists');
    }
  }

  Future<Uint8List> getCover(Book book) async {
    Uint8List? localBookCover;
    if (await ebookIsDownloaded(book)) {
      localBookCover = await (await _getRawEpubObject(book)).readCoverRaw();
    }

    return localBookCover ?? await book.cover();
  }

  Future<epubx.EpubBookRef> _getRawEpubObject(Book book) async {
    String path = await generatePath(book);
    File ebookFile = File(path);

    if (!(await ebookIsDownloaded(book))) {
      throw Exception('ebook file doesnt exists');
    }
    return await epubx.EpubReader.openBookStream(
        ebookFile.openRead(),
        ebookFile.lengthSync()
    );
  }

  Future<EpubReader> getEbookReader(Book book) async {
    return EpubReader.fromEpubBookRef(await _getRawEpubObject(book));
  }
}