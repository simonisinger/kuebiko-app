import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:image/image.dart' as image;

class BookListItemWidget extends StatefulWidget {
  final Book book;
  const BookListItemWidget({Key? key, required this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookListItemWidgetState();
}

class _BookListItemWidgetState extends State<BookListItemWidget> {

  image.Image? imageData;
  @override
  void initState() {
    super.initState();
    widget.book.cover().then((value){
      setState(() {
        imageData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imageData == null) {
      return Column(
        children: [
          SpinKitFadingCircle(
            color: Theme.of(context).shadowColor,
          )
        ],
      );
    } else {
      return Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
                Radius.circular(5)
            ),
            child: Image.memory(imageData!.getBytes())
          ),
        ],
      );
    }
  }
  
}