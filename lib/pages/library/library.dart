import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/pages/book/book_detail.dart';
import '../../event/book.dart';
import '../../pages/library/upload.dart';
import '../../services/client.dart';
import '../../widget/add_button.dart';
import '../../widget/base_scaffold.dart';
import '../../widget/book/book_image.dart';

class LibraryPage extends StatefulWidget {
  static const route = '/library';
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final List<Book> _books;

  @override
  void initState() {
    ebookAddedEvent.subscribe(_updateState);
    super.initState();
  }

  void _updateState(Value<Book> bookValue) {
    setState(() {
      _books.add(bookValue.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      FutureBuilder(
        future: ClientService.service
            .selectedLibrary!
            .books(BookSorting.name, SortingDirection.asc),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CircularProgressIndicator(color: Theme.of(context).shadowColor,);
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                _books = snapshot.data;
                return _grid();
              }
          }
        },
      ),
      floatingActionButton: ClientService.service.clientHasFeature(ClientFeature.uploadEbooks)
        ? const AddWidget(targetPath: UploadPage.route)
        : Container(),
    );
  }

  Widget _grid() {
    return GridView.builder(
      itemCount: _books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) => Container(
        margin: EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
                BookDetailPage.route,
                arguments: _books[index]
            );
          },
          child: Column(
            children: [
              BookImage(book: _books[index])
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ebookAddedEvent.unsubscribe(_updateState);
    super.dispose();
  }
}
