import 'package:html/parser.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

import '../http_client.dart';
import 'cache_controller.dart';
import 'chapter.dart';
import 'series.dart';
import 'user.dart';

class TigerTranslationsClient implements Client {
  // categories which are not a novel
  static const Set<String> _excludedCategorySlugs = {
    'news',
    'news-and-updates',
    'other',
    'uncategorized'
  };

  final TigerTranslationsHttpClient _httpClient = TigerTranslationsHttpClient();
  late final CacheController cacheController = TigerTranslationsCacheController(getAllSeries);
  final TigerTranslationsUser _user = TigerTranslationsUser();
  Future<List<TigerTranslationsChapter>>? _pages;

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
  Future<User> createUser(String email, String name, String password, List<String> role, String anilistName, String anilistToken) {
    // wont be implemented
    throw UnimplementedError();
  }

  @override
  Future<User> currentUser() async => _user;

  @override
  Future<void> delete() async {
    // nothing is stored on the website
  }

  @override
  Future<Uri> docs() {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<List<Series>> getAllSeries() async {
    List<Map<String, dynamic>> categories = (await _httpClient.getAll('categories', {
      '_fields': 'id,name,slug,parent,count,description'
    })).where((category) => !_excludedCategorySlugs.contains(category['slug'])).toList();

    List<Series> series = [];
    for (Map<String, dynamic> category in categories.where((category) => category['parent'] == 0)) {
      List<int> categoryIds = [
        category['id'],
        ...categories
            .where((child) => child['parent'] == category['id'])
            .map<int>((child) => child['id'])
      ];
      bool hasPosts = categories
          .where((element) => categoryIds.contains(element['id']))
          .any((element) => element['count'] > 0);
      if (!hasPosts) {
        continue;
      }
      series.add(TigerTranslationsSeries(
        category['id'],
        categoryIds,
        TigerTranslationsChapter.decodeTitle(category['name']),
        parseFragment(category['description'] ?? '').text ?? '',
        this,
        _httpClient
      ));
    }
    series.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return series;
  }

  /// all wordpress pages of the website, some chapters are only published as page
  Future<List<TigerTranslationsChapter>> pages() async {
    try {
      return await (_pages ??= _loadPages());
    } catch (e) {
      // don't cache failed requests
      _pages = null;
      rethrow;
    }
  }

  Future<List<TigerTranslationsChapter>> _loadPages() async {
    List<Map<String, dynamic>> rawPages = await _httpClient.getAll('pages', {'_fields': 'id,slug,date,title'});
    return rawPages
        .map((rawPage) => TigerTranslationsChapter.fromJson(TigerTranslationsChapterSource.pages, rawPage))
        .toList();
  }

  @override
  Future<List<Book>> getBooks(BookSorting sorting, SortingDirection sortingDirection) async {
    List<Book> books = [];
    for (Series series in await getAllSeries()) {
      books.addAll(await series.books(sorting, sortingDirection));
    }
    return books;
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
  bool getInitialized() => true;

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
  Future<List<User>> getUsers() async => [_user];

  @override
  void renewMetadataAll() {
    // no support
  }

  @override
  void scanAll() {
    // no support
  }

  @override
  Future<String> status() async => 'Running';

  @override
  Future<Series> createSeries({required String name, required String author, required String description, required int numberOfVolumes, required String publisher, required String language, required String genre, required int ageRating, required String type, required List<String> locked}) {
    // no support
    throw UnimplementedError();
  }
}
