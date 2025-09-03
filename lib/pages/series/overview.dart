import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/pages/book/book_detail.dart';

import '../../services/client.dart';
import '../../widget/base_scaffold.dart';
import '../../widget/book/book_image.dart';

class SeriesOverviewPage extends StatelessWidget {
  static const route = '/series';

  const SeriesOverviewPage({super.key});

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
                return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) => Container(
                    margin: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            BookDetailPage.route,
                            arguments: snapshot.data[index]
                        );
                      },
                      child: Column(
                        children: [
                          BookImage(book: snapshot.data[index])
                        ],
                      ),
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
