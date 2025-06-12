import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/pages/reader/content/content_element.dart';

mixin ProgressMixin {
  // set new progress index
  Future<void> updateProgress(ContentElement contentElement, List<List<ContentElement>> pages, Book book) async {
    // List<ContentElement> contentElements = pages.reduce((old, item) {
    //   old.addAll(item);
    //   return old;
    // });
    // int position = pages.sublist(0, contentElements.indexOf(contentElement))
    //     .fold(0, (prevValue, item) => prevValue + item.length);
    int position = 0;
    int positionOffset = 0;
    for (List<ContentElement> page in pages) {
      int tmpPosition = page.indexOf(contentElement);
      if (tmpPosition != -1) {
        position = positionOffset + positionOffset;
      }
      positionOffset += page.length;
    }

    await book.setProgress(
        Progress(
            currentPage: position,
            maxPage: positionOffset - 1
        )
    );
  }

  int getPageFromIndex(int index, List<List<ContentElement>> pages) {
    int counter = 0;
    for (List<ContentElement> page in pages) {
      counter += page.length;
      if (counter >= index) {
        return pages.indexOf(page);
      }
    }
    return counter;
  }
}