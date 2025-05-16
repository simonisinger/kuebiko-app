import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/widget/library/book_list_item.dart';

class BookListHorizontalWidget extends StatelessWidget {
  final List<Book> books;
  const BookListHorizontalWidget({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          children: [
            const SizedBox(width: 12,),
            ...books.map((Book book) => BookListItem(book: book)).toList(),
            const SizedBox(width: 12,),
          ],
        )
    );
  }
}