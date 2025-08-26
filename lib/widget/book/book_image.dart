import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import '../../services/storage/storage.dart';

class BookImage extends StatelessWidget {
  final Book book;

  const BookImage({super.key, required this.book});


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StorageService.service.getCover(book),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return CircularProgressIndicator(
              color: Theme.of(context).shadowColor,
            );
          case ConnectionState.done:
            Widget image;
            if (snapshot.hasData) {
              image = Image.memory(snapshot.data);
            } else {
                image = Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: const BorderRadius.all(Radius.circular(12))
                ),
              );
            }
            return SizedBox(
              height: 120,
              child: image,
            );
        }
      },
    );
  }
}