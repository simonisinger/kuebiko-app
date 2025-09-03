import 'package:kuebiko_client/kuebiko_client.dart';

class JNovelClubSeries implements Series {
  final String _ageRating;
  final String _type;

  JNovelClubSeries(this._ageRating, this._type);

  @override
  Future<List<Book>> books(BookSorting sorting, SortingDirection direction) {
    // TODO: implement books
    throw UnimplementedError();
  }

  @override
  String getAgeRating() => _ageRating;

  @override
  String getAuthor() {
    // TODO: implement getAuthor
    throw UnimplementedError();
  }

  @override
  String getDescription() {
    // TODO: implement getDescription
    throw UnimplementedError();
  }

  @override
  String getGenre() {
    // TODO: implement getGenre
    throw UnimplementedError();
  }

  @override
  String getLanguage() {
    // TODO: implement getLanguage
    throw UnimplementedError();
  }

  @override
  String getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  int getNumberOfVolumes() {
    // TODO: implement getNumberOfVolumes
    throw UnimplementedError();
  }

  @override
  String getPublisher() {
    // TODO: implement getPublisher
    throw UnimplementedError();
  }

  @override
  String getType() => _type.toLowerCase();

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  Series lockAgeRating() {
    // TODO: implement lockAgeRating
    throw UnimplementedError();
  }

  @override
  Series lockAuthor() {
    // TODO: implement lockAuthor
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
  Series setAgeRating(String ageRating) {
    // no support
    throw UnimplementedError();
  }

  @override
  Series setAuthor(String author) {
    // no support
    throw UnimplementedError();
  }

  @override
  Series setDescription(String description) {
    // no support
    throw UnimplementedError();
  }

  @override
  Series setGenre(String genre) {
    // no support
    throw UnimplementedError();
  }

  @override
  Series setLanguage(String language) {
    // no support
    throw UnimplementedError();
  }

  @override
  Series setName(String name) {
    // no support
    throw UnimplementedError();
  }

  @override
  Series setNumberOfVolumes(int numberOfVolumes) {
    // no support
    throw UnimplementedError();
  }

  @override
  Series setPublisher(String publisher) {
    // no support
    throw UnimplementedError();
  }

  @override
  Series setType(String type) {
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
  void update() {
    // no support
  }
}