import 'package:kuebiko_client/kuebiko_client.dart';

import '../http_client.dart';
import 'book.dart';
import 'chapter.dart';
import 'client.dart';

class TigerTranslationsSeries implements Series {
  static const int chaptersPerBook = 50;

  final int categoryId;
  // translated titles are child categories of the original title
  final List<int> categoryIds;
  final String _name;
  final String _description;
  final TigerTranslationsClient _client;
  final TigerTranslationsHttpClient _httpClient;
  List<TigerTranslationsChapter>? _chapters;

  TigerTranslationsSeries(
      this.categoryId,
      this.categoryIds,
      this._name,
      this._description,
      this._client,
      this._httpClient,
  );

  Future<List<TigerTranslationsChapter>> chapters() async {
    if (_chapters != null) {
      return _chapters!;
    }
    List<TigerTranslationsChapter> chapters = (await _httpClient.getAll('posts', {
      'categories': categoryIds.join(','),
      'orderby': 'date',
      'order': 'asc',
      '_fields': 'id,slug,date,title'
    })).map((rawPost) => TigerTranslationsChapter.fromJson(TigerTranslationsChapterSource.posts, rawPost)).toList();

    // some chapters were only published as wordpress pages, they are assigned by the slug of the posts
    Set<String> postSlugs = chapters.map((chapter) => chapter.slug).toSet();
    Set<String> postTitles = chapters.map((chapter) => chapter.title).toSet();
    Set<String> prefixes = postSlugs
        .map(TigerTranslationsChapter.slugPrefix)
        .whereType<String>()
        .toSet();
    for (TigerTranslationsChapter page in await _client.pages()) {
      // pages with the slug or title of a post are continuations of the post and loaded with it
      if (!postSlugs.contains(page.slug)
          && !postTitles.contains(page.title)
          && prefixes.contains(TigerTranslationsChapter.slugPrefix(page.slug))) {
        chapters.add(page);
      }
    }

    chapters.sort(TigerTranslationsChapter.compare);
    _chapters = chapters;
    return chapters;
  }

  @override
  Future<List<Book>> books(BookSorting sorting, SortingDirection direction) async {
    List<TigerTranslationsChapter> allChapters = await chapters();
    List<Map<String, dynamic>> latestPost = await _httpClient.getList('posts', {
      'categories': categoryIds.join(','),
      'per_page': 1,
      '_fields': 'jetpack_featured_media_url'
    });
    String? coverUrl = latestPost.isEmpty ? null : latestPost.first['jetpack_featured_media_url'];
    if (coverUrl != null && coverUrl.isEmpty) {
      coverUrl = null;
    }

    List<Book> books = [];
    for (int i = 0; i * chaptersPerBook < allChapters.length; i++) {
      List<TigerTranslationsChapter> bookChapters = allChapters.sublist(
          i * chaptersPerBook,
          ((i + 1) * chaptersPerBook).clamp(0, allChapters.length)
      );
      books.add(TigerTranslationsBook(
        // category ids are unique, so this results in an unique book id per client
        categoryId * 10000 + i,
        '$_name ${_chapterRange(bookChapters, i)}',
        this,
        bookChapters,
        coverUrl,
        _httpClient
      ));
    }
    return direction == SortingDirection.desc ? books.reversed.toList() : books;
  }

  String _chapterRange(List<TigerTranslationsChapter> bookChapters, int bookIndex) {
    int? first = bookChapters.first.number;
    int? last = bookChapters.last.number;
    if (first != null && last != null && first <= last) {
      return first == last ? '$first' : '$first-$last';
    }
    return '${bookIndex * chaptersPerBook + 1}-${bookIndex * chaptersPerBook + bookChapters.length}';
  }

  @override
  int? get ageRating => null;

  @override
  String get author => '';

  @override
  String get description => _description;

  @override
  String get genre => '';

  @override
  String get language => 'en';

  @override
  String get name => _name;

  @override
  int get numberOfVolumes => ((_chapters?.length ?? 0) / chaptersPerBook).ceil();

  @override
  String get publisher => 'Tiger Translations';

  @override
  String get type => 'web novel';

  @override
  String get id => categoryId.toString();

  @override
  Series lockAgeRating() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series lockAuthor() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series lockDescription() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series lockGenre() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series lockLanguage() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series lockName() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series lockNumberOfVolumes() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series lockPublisher() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series lockType() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockAgeRating() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockAuthor() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockDescription() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockGenre() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockLanguage() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockName() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockNumberOfVolumes() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockPublisher() {
    // no support
    throw UnimplementedError();
  }

  @override
  Series unlockType() {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<void> update() {
    // no support
    throw UnimplementedError();
  }

  @override
  set ageRating(int? ageRating) {
    // no support
    throw UnimplementedError();
  }

  @override
  set author(String? author) {
    // no support
    throw UnimplementedError();
  }

  @override
  set description(String description) {
    // no support
    throw UnimplementedError();
  }

  @override
  set genre(String genre) {
    // no support
    throw UnimplementedError();
  }

  @override
  set language(String language) {
    // no support
    throw UnimplementedError();
  }

  @override
  set name(String name) {
    // no support
    throw UnimplementedError();
  }

  @override
  set numberOfVolumes(int? numberOfVolumes) {
    // no support
    throw UnimplementedError();
  }

  @override
  set publisher(String publisher) {
    // no support
    throw UnimplementedError();
  }

  @override
  set type(String type) {
    // no support
    throw UnimplementedError();
  }
}
