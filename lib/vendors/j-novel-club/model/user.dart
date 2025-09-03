import 'package:kuebiko_client/kuebiko_client.dart';

class JNovelClubUser implements User {
  @override
  String email;

  @override
  String name;

  @override
  List<String> roles;

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
  Future<List<Book>> finishedBooks() {
    // TODO: implement finishedBooks
    throw UnimplementedError();
  }

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  set newPassword(String newPassword) {
    // TODO: implement newPassword
  }

  @override
  Future<List<Book>> readingBooks() {
    // TODO: implement readingBooks
    throw UnimplementedError();
  }

  @override
  void tokenDelete(int tokenId) {
    // TODO: implement tokenDelete
  }

  @override
  Future<List<Book>> unreadBooks() {
    // TODO: implement unreadBooks
    throw UnimplementedError();
  }

  @override
  Future<void> update(String passwords) {
    // support later
    throw UnimplementedError();
  }
}