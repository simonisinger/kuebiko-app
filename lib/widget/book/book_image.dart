import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/services/storage/storage.dart';

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
            return SpinKitDualRing(
              color: Theme.of(context).shadowColor,
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              return Image.memory(snapshot.data.buffer.asUint8List());
            } else {
              return Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: const BorderRadius.all(Radius.circular(12))
                ),
              );
            }
        }
      },
    );
  }
}