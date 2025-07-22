import 'package:kuebiko_client/kuebiko_client.dart';

class LocalUser implements User {
  @override
  Future<void> delete(String password) {
    // wont be implemented
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> finishedBooks() {
    // TODO: implement finishedBooks
    throw UnimplementedError();
  }

  @override
  String getEmail() {
    // no email needed
    throw UnimplementedError();
  }

  @override
  String getName() {
    // no need
    throw UnimplementedError();
  }

  @override
  List<String> getRoles() {
    // roles are obsolete for this
    throw UnimplementedError();
  }

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  Future<List<Book>> readingBooks() {
    // TODO: implement readingBooks
    throw UnimplementedError();
  }

  @override
  void tokenDelete(int tokenId) {
    // no token needed
  }

  @override
  Future<List<Book>> unreadBooks() {
    // TODO: implement unreadBooks
    throw UnimplementedError();
  }

  @override
  void update(String password) {
    // also obsolete for local
    throw UnimplementedError();
  }
}