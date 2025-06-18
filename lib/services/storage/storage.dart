import 'dart:io';

import 'package:epubx/epubx.dart' as epubx;
import 'package:file_picker/file_picker.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/services/ebook/ebook.dart';
import 'package:path_provider/path_provider.dart';

import '../ebook/epub_reader.dart';

class StorageService {
  static final StorageService service = StorageService();

  Future<String> _generatePath(Book book) async {
    Directory baseDirectory = await getApplicationDocumentsDirectory();
    String domain = ClientService.service.selectedClient!.getConfig().baseUrl.host;
    return '${baseDirectory.path}/$domain-${book.id}.epub';
  }

  Future<bool> ebookIsDownloaded(Book book) async {
    String path = await _generatePath(book);
    File ebookFile = File(path);
    return ebookFile.existsSync();
  }

  Future<void> deleteEbook(Book book) async {
    File(await _generatePath(book)).deleteSync();
  }

  Future<void> uploadEbook(PlatformFile file) async {
    BookMeta meta = await EbookService.parseEpubMeta(file.name, file.xFile.openRead(), file.size);
    await ClientService.service.selectedLibrary!.upload(
        file.name,
        meta,
        file.xFile.openRead(),
        file.size
    );
  }

  Stream<double> downloadEbook(Book book) async* {
    String path = await _generatePath(book);
    File ebookFile = File(path);
    if (!(await ebookIsDownloaded(book))) {
      final download = await book.download(Formats.epub);
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

  Future<EpubReader> getEbookReader(Book book) async {
    String path = await _generatePath(book);
    File ebookFile = File(path);

    if (!(await ebookIsDownloaded(book))) {
      throw Exception('ebook file doesnt exists');
    }

    return EpubReader.fromEpubBookRef(
        await epubx.EpubReader.openBookStream(
          ebookFile.openRead(),
          ebookFile.lengthSync()
        )
    );
  }
}