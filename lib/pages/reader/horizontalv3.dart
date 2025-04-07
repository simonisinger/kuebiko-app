import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../../enum/read_direction.dart';
import '../../services/ebook/epub_reader.dart';
import 'content/content_element.dart';

enum _ChangePageDirection {
  up,
  down
}

class HorizontalV3ReaderPage extends StatefulWidget {
  final ReadDirection direction;
  const HorizontalV3ReaderPage({Key? key, this.direction = ReadDirection.ltr}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HorizontalV3ReaderPageState();
}

class _HorizontalV3ReaderPageState extends State<HorizontalV3ReaderPage> {

  EpubReader? _ebook;
  Map<String, Map<String, List<ContentElement>>> _contentElements = {};
  late String _chapter;
  final List<List<ContentElement>> _pages = [];
  bool _showMenu = false;
  final PageController _pageController = PageController(initialPage: 0);
  double? _initialDragPosition;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _initEbook();
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
  Widget _getPageWidget(List<ContentElement> page) => Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: page.map((e) => e.render()).toList(),
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
      setState(() {
        _showMenu = !_showMenu;
      });
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
    setState(() {
      _page = page;
    });

    if (_pages[page].isNotEmpty) {
      ContentElement targetElement = _pages[page].first;
      for (String key in _contentElements.keys) {
        List<ContentElement> chapterElements = _contentElements[key]!
            .values
            .reduce((a, b) {
          a.addAll(b);
          return a;
        });
        if (chapterElements.contains(targetElement)) {
          _chapter = key;
          break;
        }
      }
    }
  }

  Widget _showReader() {
    final ThemeData theme = Theme.of(context);
    return Stack(
        children: [
          GestureDetector(
            child: PageView(
              controller: _pageController,
              children: _pages.map((e) => _getPageWidget(e)).toList(),
              onPageChanged: _updateChapter,
            ),
            onTapUp: _readerTap,
            onHorizontalDragStart: _readerHorizontalDragStart,
            onHorizontalDragUpdate: _readerHorizontalDragUpdate,
            onHorizontalDragCancel: _readerHorizontalDragCancel,
            onHorizontalDragEnd: _readerHorizontalDragEnd,
          ),
          _showMenu ? Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(
                    color: theme.primaryColor
                ),
                child: Column(
                  children: [
                    Text(
                      _chapter,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: theme.scaffoldBackgroundColor
                      ),
                    ),
                  ],
                ),
              )
          ) : Container(),
          _showMenu ? Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: theme.primaryColor
                  ),
                  child: Column(
                      children: [
                        Slider(
                            value: _pageController.page!,
                            min: 0,
                            max: _pages.length.toDouble(),
                            activeColor: _ebook?.readDirection == ReadDirection.ltr ? theme.scaffoldBackgroundColor : Colors.white,
                            inactiveColor: _ebook?.readDirection == ReadDirection.ltr ? Colors.white : theme.scaffoldBackgroundColor,
                            onChanged: (double newPage) {
                              setState(() {
                                _pageController.jumpToPage(newPage.toInt());
                              });
                            },
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "${_ebook!.readDirection == ReadDirection.ltr ? _page + 1 : _pages.length - _page} / ${_pages.length}",
                            style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor
                            ),
                          )
                        )
                      ]
                  )
              )
          ) : Container(),
        ]
    );
  }

  void _changePage(_ChangePageDirection direction) {
    setState(() {
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
      _page = newPage;
      _pageController.animateToPage(
          newPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.decelerate
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _ebook == null ? _showLoading() : _showReader(),
      ),
    );
  }

  _initEbook() async {
    http.Response res = await http.get(Uri.parse('testlink'));
    _ebook = await EpubReader.init(res.bodyBytes);
    _contentElements = _ebook!.convertToObjects();
    _chapter = _contentElements.keys.first;

    double deviceHeight = MediaQuery.of(context).size.height;
    double maxHeight = deviceHeight * 0.8;
    List<List<ContentElement>> pages = [];
    _contentElements.forEach((key, value) {
      value.forEach((key, contentElements) {

        List<double> heights = EpubReader.generateHeight(
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
      });
    });

    if (_ebook!.readDirection == ReadDirection.rtl) {
      _pages.addAll(pages.reversed);
    } else {
      _pages.addAll(pages);
    }

    setState((){});
  }
}