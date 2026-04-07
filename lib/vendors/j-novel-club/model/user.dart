import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/vendors/j-novel-club/http_client.dart';

class JNovelClubUser implements User {
  final String _id;
  final String _email;
  final String _nickname;
  final JNovelClubHttpClient _httpClient;

  JNovelClubUser(this._id, this._email, this._nickname, this._httpClient);

  @override
  String get email => _email;

  @override
  String get name => _nickname;

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
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  set newPassword(String newPassword) {
    // TODO: implement newPassword
  }

  @override
  Future<List<Book>> readingBooks() async {
    return [];
  }

  @override
  void tokenDelete(int tokenId) {
    // TODO: implement tokenDelete
  }

  @override
  Future<List<Book>> unreadBooks() async {
    return [];
  }

  @override
  Future<void> update(String passwords) {
    // support later
    throw UnimplementedError();
  }

  @override
  set email(String email) {
    // wont be implemented
  }

  @override
  set name(String name) {
    // wont be implemented
  }
}