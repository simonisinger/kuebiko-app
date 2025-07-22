import 'dart:convert';
import 'dart:io';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/vendors/local/model/library.dart';
import 'package:kuebiko_web_client/vendors/local/model/user.dart';

import '../../../cache/storage.dart';
import 'package:path/path.dart' as p;

class LocalClient implements Client {
  final LocalUser user = LocalUser();
  static const String librariesListKey = 'localClient.libraries';

  @override
  Future<void> createFolder(String path) {
    // TODO: implement createFolder
    throw UnimplementedError();
  }

  @override
  Future<Library> createLibrary(String name, String path) {
    // TODO: implement createLibrary
    throw UnimplementedError();
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
  Future<List<Book>> getBooks(BookSorting sorting, SortingDirection sortingDirection) {
    // TODO: implement getBooks
    throw UnimplementedError();
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
    String librariesString = await storage.read(key: librariesListKey) ?? '[]';
    List librariesRaw = jsonDecode(librariesString);
    return librariesRaw
        // TODO: set correct path
        .map((libraryName) => LocalLibrary(libraryName, ''))
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
    // no needs
  }

  @override
  void scanAll() {
    // TODO: implement scanAll
  }

  @override
  Future<String> status() async => 'Running';
}