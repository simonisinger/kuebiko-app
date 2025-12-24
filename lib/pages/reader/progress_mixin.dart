import 'dart:convert';

import 'package:kuebiko_client/kuebiko_client.dart';

import '../../cache/storage.dart';
import '../../enum/read_direction.dart';
import '../../pages/reader/content/content_element.dart';
import '../../services/client.dart';
import '../../services/ebook/ebook.dart';

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

    if (ClientService.service.clientHasFeature(ClientFeature.progressCache)) {
      await storage.write(key: getLocalStorageKey(book), value: position.toString());
    }
    try {
      await book.setProgress(
          Progress(
              currentPage: position,
              maxPage: positionOffset - 1
          )
      );
    } catch (e) {
      String unsynchedString = await storage.read(key: EbookService.progressUnsynchedKey) ?? '[]';
      List unsynched = jsonDecode(unsynchedString);
      unsynched.add({
        'currentPage': position,
        'maxPage': positionOffset - 1
      });
      await storage.write(key: EbookService.progressUnsynchedKey, value: jsonEncode(unsynched));
    }
  }

  int _getMaxPage(List<List<ContentElement>> pages) {
    int positionOffset = 0;
    for (List<ContentElement> page in pages) {
      positionOffset += page.length;
    }
    return positionOffset;
  }

  static String getLocalStorageKey(Book book) => 'progress.${ClientService.service.getCurrentLocalName()}.${book.id}';

  Future<Progress> getProgress(Book book, List<List<ContentElement>> pages) async {
    Progress progress;
    int maxPage = _getMaxPage(pages);
    try {
      progress = await book.getProgress();
    } catch(e) {
      String? progressString;
      if (ClientService.service.clientHasFeature(ClientFeature.progressCache)) {
        progressString = await storage.read(key: getLocalStorageKey(book));
      }
      if (progressString != null) {
        Map progressMap = jsonDecode(progressString);
        progress = Progress(currentPage: progressMap['currentPage'], maxPage: maxPage);
      } else {
        progress = Progress(currentPage: 0, maxPage: maxPage);
      }
    }
    return progress;
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