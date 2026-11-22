import 'package:kuebiko_client/kuebiko_client.dart';

/// tiger translations can be read without an account, so this is only an anonymous user
class TigerTranslationsUser implements User {
  @override
  String get email => '';

  @override
  String get name => 'Tiger Translations';

  @override
  List<String> roles = ['User'];

  @override
  Future<void> adminUpdate() {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String password) {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> finishedBooks() async {
    return [];
  }

  @override
  // no support
  int get id => throw UnimplementedError();

  @override
  set newPassword(String newPassword) {
    // no support
  }

  @override
  Future<List<Book>> readingBooks() async {
    return [];
  }

  @override
  void tokenDelete(int tokenId) {
    // no support
  }

  @override
  Future<List<Book>> unreadBooks() async {
    return [];
  }

  @override
  Future<void> update(String passwords) {
    // no support
    throw UnimplementedError();
  }

  @override
  set email(String email) {
    // no support
  }

  @override
  set name(String name) {
    // no support
  }
}
