import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import '../../widget/library/book_list_item.dart';

class BookListHorizontalWidget extends StatelessWidget {
  final List<Book> books;
  const BookListHorizontalWidget({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          children: [
            const SizedBox(width: 12,),
            ...books.map((Book book) => BookListItem(book: book)),
            const SizedBox(width: 12,),
          ],
        )
    );
  }
}