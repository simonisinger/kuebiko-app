import 'package:kuebiko_client/kuebiko_client.dart';

class JNovelClubSeries implements Series {
  final String _id;
  final String _name;
  final String _author;
  final String _description;
  final int _numberOfVolumes;
  final String _publisher;
  final String _language;
  final String _genre;
  final int? _ageRating;
  final String _type;
  final CacheController _cacheController;

  JNovelClubSeries(
      this._id,
      this._name,
      this._author,
      this._description,
      this._numberOfVolumes,
      this._publisher,
      this._language,
      this._genre,
      this._ageRating,
      this._type,
      this._cacheController,
  );

  @override
  Future<List<Book>> books(BookSorting sorting, SortingDirection direction) {
    // TODO: implement books
    throw UnimplementedError();
  }

  @override
  int? get ageRating => _ageRating;

  @override
  String get author => _author;

  @override
  String get description => _description;

  @override
  String get genre => _genre;

  @override
  String get language => _language;

  @override
  String get name => _name;

  @override
  int get numberOfVolumes => _numberOfVolumes;

  @override
  String get publisher => _publisher;

  @override
  String get type => _type.toLowerCase();

  @override
  String get id => _id;

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