import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/enum/book_type.dart';
import 'package:kuebiko_web_client/pages/reader/progress_mixin.dart';
import 'package:kuebiko_web_client/services/ebook/ebook.dart';
import 'package:kuebiko_web_client/services/ebook/reader_interface.dart';
import 'package:kuebiko_web_client/services/storage/storage.dart';
import 'package:kuebiko_web_client/widget/reader/overlay_bottom.dart';
import 'package:kuebiko_web_client/widget/reader/overlay_top.dart';

import '../../enum/read_direction.dart';
import 'content/content_element.dart';

enum _ChangePageDirection {
  up,
  down
}

class HorizontalV3ReaderPage extends StatefulWidget {
  static final Event<Value<int>> pageUpdatedEvent = Event();
  static final Event<Value<bool>> showMenuChangedEvent = Event();
  final Book book;
  const HorizontalV3ReaderPage({Key? key, required this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HorizontalV3ReaderPageState();
}

class _HorizontalV3ReaderPageState extends State<HorizontalV3ReaderPage> with ProgressMixin {
  late final Reader reader;
  Map<String, Map<String, List<ContentElement>>> _contentElements = {};
  late final List<List<ContentElement>> _pages;
  bool _showMenu = false;
  late final PageController _pageController;
  double? _initialDragPosition;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initEbook());
  }

  Widget _showLoading() {
    return Stack(
        children: [
          Positioned.fill(
            child: Container(
              alignment: Alignment.topCenter,
              child: SpinKitDualRing(
                color: Theme.of(context).shadowColor,
                size: 100,
              ),
            ),
          ),
          Positioned.fill(
              child: Container(
                  margin: const EdgeInsets.only(top: 200),
                  alignment: AlignmentDirectional.center,
                  child: const Text(
                    'Ebook wird geladen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                  )
              )
          )
        ]
    );
  }

  Widget _getPageWidget(BuildContext context, int index) => Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: _pages[index].map((e) => e.render()).toList(),
      )
  );

  void _readerTap(TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final prevPage = width / 3;
    final nextPage = prevPage * 2;
    final position = details.globalPosition.dx;
    if (prevPage > position) {
      _changePage(_ChangePageDirection.down);
    } else if (nextPage < position) {
      _changePage(_ChangePageDirection.up);
    } else {
      _showMenu = !_showMenu;
      HorizontalV3ReaderPage.showMenuChangedEvent.broadcast(Value(_showMenu));
    }
  }

  void _readerHorizontalDragStart(DragStartDetails details) {
    _initialDragPosition = details.globalPosition.dx;
  }

  void _readerHorizontalDragUpdate(DragUpdateDetails details) {
    final width = MediaQuery.of(context).size.width;
    _pageController.page! * width + ((details.globalPosition.dx - _initialDragPosition!) * -1);
  }

  void _readerHorizontalDragCancel() {
    _initialDragPosition = null;
  }

  void _readerHorizontalDragEnd(DragEndDetails details) {
    _initialDragPosition = null;
  }

  _updateChapter(int page) {
    HorizontalV3ReaderPage.pageUpdatedEvent.broadcast(Value(page));
    updateProgress(_pages[page].first, _pages, widget.book);
  }

  Widget _showReader() {
    return Stack(
        children: [
          KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (KeyEvent keyEvent) {

            },
            child: GestureDetector(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _updateChapter,
                itemBuilder: _getPageWidget,
                itemCount: _pages.length,
              ),
              onTapUp: _readerTap,
              onHorizontalDragStart: _readerHorizontalDragStart,
              onHorizontalDragUpdate: _readerHorizontalDragUpdate,
              onHorizontalDragCancel: _readerHorizontalDragCancel,
              onHorizontalDragEnd: _readerHorizontalDragEnd,
            ),
          ),
          ReaderOverlayTop(
            pages: _pages,
            contentElements: _contentElements,
          ),
          ReaderOverlayBottom(
            readDirection: reader.readDirection,
            pageController: _pageController,
            countPages: _pages.length
          ),
        ]
    );
  }

  void _changePage(_ChangePageDirection direction) {
    int newPage = _pageController.page!.ceil();
    switch (direction) {
      case _ChangePageDirection.up:
        newPage++;
        if (newPage == _pages.length) {
          return;
        }
      case _ChangePageDirection.down:
        if (newPage == 0) {
          return;
        }
        newPage--;
    }
    HorizontalV3ReaderPage.pageUpdatedEvent.broadcast(Value(newPage));
    _pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.decelerate
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _isLoaded ? _showReader() : _showLoading(),
      ),
    );
  }

  _initEbook() async {
    reader = await StorageService.service.getEbookReader(widget.book);
    _contentElements = await reader.convertToObjects();

    double deviceHeight = MediaQuery.of(context).size.height;
    double maxHeight = deviceHeight * 0.8;
    List<List<ContentElement>> pages = [];
    for (String chapter in _contentElements.keys) {
      for (String filename in _contentElements[chapter]!.keys.toList()) {
        List<ContentElement> contentElements = _contentElements[chapter]![filename]!;

        if (reader.bookType == BookType.novel) {
          List<double> heights = await EbookService.generateHeight(
              contentElements,
              MediaQuery.of(context).size.width,
              maxHeight
          );
          double tmpPageSize = 0;
          List<ContentElement> tmpPage = [];
          for (int i = 0; i < heights.length; i++) {
            tmpPageSize += heights[i];
            if (tmpPageSize > maxHeight) {
              pages.add(tmpPage);
              tmpPageSize = heights[i];
              tmpPage = [contentElements[i]];
            } else {
              tmpPage.add(contentElements[i]);
            }
          }
          if (tmpPage.isNotEmpty) {
            pages.add(tmpPage);
          }
        } else {
          pages.add(List.unmodifiable(contentElements));
        }
      }
    }

    if (reader.readDirection == ReadDirection.rtl) {
      _pages = List.unmodifiable(pages.reversed);
    } else {
      _pages = List.unmodifiable(pages);
    }

    Progress progress = await widget.book.getProgress();
    _pageController = PageController(
        initialPage: getPageFromIndex(
            progress.currentPage.toInt(),
            pages,
            reader.readDirection
        )
    );

    setState((){
      _isLoaded = true;
    });
  }
}