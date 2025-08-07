import 'dart:io';
import 'dart:typed_data';

import 'package:epubx_kuebiko/epubx_kuebiko.dart' as epubx;
import 'package:file_picker/file_picker.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/services/ebook/ebook.dart';
import 'package:path_provider/path_provider.dart';

import '../ebook/epub_reader.dart';

class StorageService {
  static final StorageService service = StorageService();

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
    BookMeta meta = await EbookService.parseEpubMeta(file.name, file.xFile.openRead(), file.size);
    return ClientService.service.selectedLibrary!.upload(
        file.name,
        meta,
        file.xFile.openRead(),
        file.size
    );
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

    return localBookCover ?? book.cover();
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