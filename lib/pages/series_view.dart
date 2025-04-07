import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/pages/home/book_list_item.dart';

class SeriesViewPage extends StatefulWidget {
  final Series series;
  const SeriesViewPage({Key? key, required this.series}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SeriesViewPageState();
}

class _SeriesViewPageState extends State<SeriesViewPage> {

  List<Book>? _books;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: Text(widget.series.getName()),
              ),
              Wrap(
                children: _books == null ? [SpinKitFadingCircle()] : _generateBookWidgets(),
              )
            ]
        )
    );
  }

  List<Widget> _generateBookWidgets() {
    List<Widget> books = [];
    for (Book book in _books!) {
      books.add(BookListItemWidget(book: book));
    }
    return books;
  }
}