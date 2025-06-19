import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/pages/library/upload.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/widget/add_button.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';
import 'package:kuebiko_web_client/widget/book/book_image.dart';

class LibraryPage extends StatefulWidget {
  static const route = '/library';
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

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
              return SpinKitDualRing(color: Theme.of(context).shadowColor,);
            case ConnectionState.done:
              return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) => Column(
                  children: [
                    BookImage(book: snapshot.data[index])
                  ],
                ),
              );
          }
        },
      ),
      floatingActionButton: const AddWidget(targetPath: UploadPage.route),
    );
  }
}
