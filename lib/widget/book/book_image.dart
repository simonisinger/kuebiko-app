import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart' as image;
import 'package:kuebiko_client/kuebiko_client.dart';

class BookImage extends StatefulWidget {
  final Book book;

  const BookImage({super.key, required this.book});


  @override
  State<BookImage> createState() => _BookImageState();
}

class _BookImageState extends State<BookImage> {
  bool _imageLoaded = false;

  image.Image? cover;

  @override
  void initState() {
    super.initState();
      widget.book.cover().then((image.Image? image) {
        setState(() {
          cover = image;
          _imageLoaded = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!_imageLoaded) {
      return SpinKitDualRing(
        color: Theme.of(context).shadowColor,
      );
    } else if (cover != null) {
      return Image.memory(cover!.buffer.asUint8List());
    } else {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: const BorderRadius.all(Radius.circular(12))
        ),
      );
    }
  }
}