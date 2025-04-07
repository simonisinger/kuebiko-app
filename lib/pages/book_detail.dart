import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;
  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  Image? cover;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(

          )
        ],
      )
    );
  }
}