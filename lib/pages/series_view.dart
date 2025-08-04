import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/widget/library/book_list_item.dart';

class SeriesViewPage extends StatelessWidget {
  final Series series;
  const SeriesViewPage({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: Text(series.getName()),
              ),
              FutureBuilder(
                    future: series.books(BookSorting.name, SortingDirection.asc),
                    builder: (context, snapshot) {
                      switch(snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return CircularProgressIndicator();
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            return Wrap(children: _generateBookWidgets(snapshot.data!));
                          } else {
                            // TODO add detailed error message
                            return Text(snapshot.error.toString());
                          }
                      }
              })
            ]
        )
    );
  }

  List<Widget> _generateBookWidgets(List<Book> books) {
    List<Widget> bookWidgets = [];
    for (Book book in books) {
      bookWidgets.add(BookListItem(book: book));
    }
    return bookWidgets;
  }
}