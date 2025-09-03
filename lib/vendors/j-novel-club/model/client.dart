import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/vendors/j-novel-club/model/series.dart';

class JNovelClubClient implements Client {
  final _httpClient = Dio();
  final String baseDomain = 'https://labs.j-novel.club';

  @override
  Future<void> createFolder(String path) {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<Library> createLibrary(String name, String path) {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<Series> createSeries({required String name, required String author, required String description, required int numberOfVolumes, required String publisher, required String language, required String genre, required String ageRating, required String type, required List<String> locked}) {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<User> createUser(String email, String name, String password, List<String> role, String anilistName, String anilistToken) {
    // wont be implemented
    throw UnimplementedError();
  }

  @override
  Future<User> currentUser() {
    Dio();
  }

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Uri> docs() {
    // TODO: implement docs
    throw UnimplementedError();
  }

  @override
  Future<List<Series>> getAllSeries() async {
    Response res = await _httpClient.get('$baseDomain/app/v2/series?format=json');
    Map<String, dynamic> data = res.data is Map ? res.data : jsonDecode(res.data);
    return data['series'].map((seriesRaw) => JNovelClubSeries(
      seriesRaw['id'],
      seriesRaw['title'],
      '',   // author
      seriesRaw['description'],
      0, // TODO numberOfVolumes refactor it that it will be retrieved dynamically
      'J-Novel Club',
      'en',
      seriesRaw['tags'].join(','),
      seriesRaw['ageRating'],
      seriesRaw['type'],

    ));
  }

  @override
  Future<List<Book>> getBooks(BookSorting sorting, SortingDirection sortingDirection) {
    // TODO: implement getBooks
    throw UnimplementedError();
  }

  @override
  KuebikoConfig getConfig() {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getFolderContent(String path) {
    // no support
    throw UnimplementedError();
  }

  @override
  bool getInitialized() {
    // TODO: implement getInitialized
    throw UnimplementedError();
  }

  @override
  Future<List<Library>> getLibraries() {
    // no support
    throw UnimplementedError();
  }

  @override
  Settings getSettings() {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getUsers() {
    // no support
    throw UnimplementedError();
  }

  @override
  void renewMetadataAll() {
    // no support
  }

  @override
  void scanAll() {
    // no support
  }

  @override
  Future<String> status() {
    // TODO: implement status
    throw UnimplementedError();
  }
}