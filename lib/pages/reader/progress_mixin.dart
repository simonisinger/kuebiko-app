import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/enum/read_direction.dart';
import 'package:kuebiko_web_client/pages/reader/content/content_element.dart';

mixin ProgressMixin {
  // set new progress index
  Future<void> updateProgress(
      ContentElement contentElement,
      List<List<ContentElement>> pages,
      Book book,
      ReadDirection readDirection
  ) async {
    int position = 0;
    int positionOffset = 0;
    int lastPageIndex = pages.length - 1;
    for (List<ContentElement> page in pages) {
      int tmpPosition = page.indexOf(contentElement);
      if (tmpPosition != -1) {
        position = tmpPosition + positionOffset;
      }
      positionOffset += page.length;
    }

    if (readDirection == ReadDirection.rtl) {
      lastPageIndex = 0;
      position = pages.length - position;
    }

    if (contentElement == pages[lastPageIndex].first) {
      position = positionOffset;
    }

    await book.setProgress(
        Progress(
            currentPage: position,
            maxPage: positionOffset - 1
        )
    );
  }

  int getPageFromIndex(int index, List<List<ContentElement>> pages, ReadDirection readDirection) {
    int counter = 0;
    int pageIndex = 0;
    for (List<ContentElement> page in pages) {
      counter += page.length;
      if (counter >= index) {
        pageIndex = pages.indexOf(page);
        break;
      }
    }
    return readDirection == ReadDirection.ltr ? pageIndex : pages.length - counter;
  }
}