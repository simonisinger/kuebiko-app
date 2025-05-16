import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/widget/book/book_image.dart';

class BookListItem extends StatelessWidget {
  final Book book;

  const BookListItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/book/detail', arguments: book);
      },
      child: SizedBox(
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor
                    ),
                    child: BookImage(book: book,)
                )
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(bottom: 4),
              child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  book.name,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
