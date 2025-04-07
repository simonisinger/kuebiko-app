import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

class BookListHorizontalWidget extends StatelessWidget {
  final List<Book> books;
  const BookListHorizontalWidget({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: books.map((Book book){
        return Column(
          children: [

          ],
        );
      }).toList(),
    );
  }
}