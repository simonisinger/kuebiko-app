import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
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
                  itemBuilder: (BuildContext context, int index) =>
                      Container(
                        margin: EdgeInsets.all(4),
                        child: GestureDetector(
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
      floatingActionButton: ClientService.service.clientHasFeature(ClientFeature.uploadEbooks)
        ? const AddWidget(targetPath: UploadPage.route)
        : Container(),
    );
  }
}
