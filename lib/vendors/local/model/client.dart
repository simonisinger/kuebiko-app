import 'dart:convert';
import 'dart:io';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/vendors/local/model/library.dart';
import 'package:kuebiko_web_client/vendors/local/model/user.dart';
import 'package:path_provider/path_provider.dart';

import '../../../cache/storage.dart';
import 'package:path/path.dart' as p;

class LocalClient implements Client {

  final String name;
  final LocalUser user = LocalUser();

  LocalClient(this.name);
  String get librariesListKey => 'localClient.$name.libraries';


  @override
  Future<void> createFolder(String path) {
    // not needed
    throw UnimplementedError();
  }

  @override
  Future<Library> createLibrary(String name, String path) async {
    LocalLibrary library = LocalLibrary(name, (await getApplicationDocumentsDirectory()).path + path);
    List libraryNames = jsonDecode(await storage.read(key: librariesListKey) ?? '[]')
      ..add(name);

    Directory baseDirectory = await getApplicationDocumentsDirectory();
    Directory libraryFolder = Directory('${baseDirectory.path}/${this.name}$path');
    if (!libraryFolder.existsSync()) {
      libraryFolder.createSync();
    }

    await storage.write(key: librariesListKey, value: jsonEncode(libraryNames));
    return library;
  }

  @override
  Future<Series> createSeries({required String name, required String author, required String description, required int numberOfVolumes, required String publisher, required String language, required String genre, required String ageRating, required String type, required List<String> locked}) {
    // TODO: implement createSeries
    throw UnimplementedError();
  }

  @override
  Future<User> createUser(String email, String name, String password, List<String> role, String anilistName, String anilistToken) {
    // no need
    throw UnimplementedError();
  }

  @override
  Future<User> currentUser() async => user;

  @override
  Future<Uri> docs() {
    // maybe implement in the future
    throw UnimplementedError();
  }

  @override
  Future<List<Series>> getAllSeries() {
    // TODO: implement getAllSeries
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> getBooks(BookSorting sorting, SortingDirection sortingDirection) async {
    List<Library> libraries = await getLibraries();
    List<Book> ebooks = [];
    for (Library library in libraries) {
      ebooks.addAll(await library.books(sorting, sortingDirection));
    }
    return ebooks..sort((Book a, Book b) {
      if (sortingDirection == SortingDirection.desc) {
        return a.name.compareTo(b.name);
      } else {
        return b.name.compareTo(a.name);
      }
    });
  }

  @override
  KuebikoConfig getConfig() {
    // maybe in the future
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getFolderContent(String path) async {
    return (await Directory(path).list(recursive: true).toList())
        .map((file) => p.basename(file.path))
        .toList();
  }

  @override
  bool getInitialized() => true;

  @override
  Future<List<Library>> getLibraries() async {
    String basePath = (await getApplicationDocumentsDirectory()).path;
    String librariesString = await storage.read(key: librariesListKey) ?? '[]';
    List librariesRaw = jsonDecode(librariesString);
    return librariesRaw
        .map((libraryName) => LocalLibrary(libraryName, '$basePath/$libraryName'))
        .toList();
  }

  @override
  Settings getSettings() {
    // maybe in the future specific settings for the client
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getUsers() async => [user];

  @override
  void renewMetadataAll() {
    // TODO: implement renewMetadataAll
  }

  @override
  void scanAll() {
    // TODO: implement scanAll
  }

  @override
  Future<String> status() async => 'Running';

  @override
  Future<void> delete() async {
    List<Library> libraries = await getLibraries();
    for (Library library in libraries) {
      await library.delete();
    }
    await storage.delete(key: librariesListKey);
  }
}