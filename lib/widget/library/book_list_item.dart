import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import '../../generated/i18n/app_localizations.dart';
import '../../widget/book/book_image.dart';

class BookListItem extends StatelessWidget {
  final Book book;

  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    Future metadataFuture = book.metadata();
    const EdgeInsets textPadding = EdgeInsets.symmetric(horizontal: 4);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/book/detail', arguments: book);
      },
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Container(
                    width: double.infinity,
                    height: 164,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor
                    ),
                    child: BookImage(book: book,)
                )
            ),
            Container(
              padding: textPadding,
              child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  book.name,
              ),
            ),
            FutureBuilder(
                future: metadataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data['number_of_volume'] != null) {
                    return Container(
                      padding: textPadding,
                      child: Text(
                        localizations.volume(snapshot.data!['number_of_volume']),
                      ),
                    );
                  }
                  return Container();
                }
            )
          ],
        ),
      ),
    );
  }
}
