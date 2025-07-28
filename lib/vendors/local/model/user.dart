import 'dart:convert';

import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/cache/storage.dart';
import 'package:kuebiko_web_client/pages/reader/progress_mixin.dart';
import 'package:kuebiko_web_client/services/client.dart';

class LocalUser implements User {
  @override
  Future<void> delete(String password) {
    // wont be implemented
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> finishedBooks() {
    return _getBooksByReadingByStatus((progressMap) {
      return progressMap['currentPage'] != 0 &&
          progressMap['currentPage'] == progressMap['maxPage'];
    });
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
  Future<List<Book>> readingBooks() async {
    return _getBooksByReadingByStatus((progressMap) {
      return progressMap['currentPage'] != 0 &&
          progressMap['currentPage'] != progressMap['maxPage'];
    });
  }

  Future<List<Book>> _getBooksByReadingByStatus(bool Function(Map) checkFunction) async {
    List<Book> books = await ClientService.service
        .selectedClient!
        .getBooks(BookSorting.name, SortingDirection.asc);

    List<Book> statusBooks = [];
    for (Book book in books) {
      String key = ProgressMixin.getLocalStorageKey(book);
      Map progressMap = jsonDecode(await storage.read(key: key) ?? '{"currentPage": 0, "maxPage": 1000}');
      if (checkFunction(progressMap)) {
        statusBooks.add(book);
      }
    }
    return statusBooks;
  }

  @override
  void tokenDelete(int tokenId) {
    // no token needed
  }

  @override
  Future<List<Book>> unreadBooks() {
    return _getBooksByReadingByStatus((progressMap) {
      return progressMap['currentPage'] == 0;
    });
  }

  @override
  void update(String password) {
    // also obsolete for local
    throw UnimplementedError();
  }
}