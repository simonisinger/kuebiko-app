import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_web_client/services/ebook/ebook.dart';
import 'package:kuebiko_web_client/services/ebook/reader_interface.dart';

import '../../enum/read_direction.dart';
import 'content/content_element.dart';

enum _ChangePageDirection {
  up,
  down
}

class HorizontalV3ReaderPage extends StatefulWidget {
  final Reader reader;
  const HorizontalV3ReaderPage({Key? key, required this.reader}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HorizontalV3ReaderPageState();
}

class _HorizontalV3ReaderPageState extends State<HorizontalV3ReaderPage> {
  Map<String, Map<String, List<ContentElement>>> _contentElements = {};
  late String _chapter;
  final List<List<ContentElement>> _pages = [];
  bool _showMenu = false;
  final PageController _pageController = PageController(initialPage: 0);
  double? _initialDragPosition;
  int _page = 0;
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
      // iterate through the elements to find the right chapter
      for (String key in _contentElements.keys) {
        List<ContentElement> chapterElements = _contentElements[key]!.values.reduce((a, b) {
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
                            activeColor: widget.reader.readDirection == ReadDirection.ltr ? theme.scaffoldBackgroundColor : Colors.white,
                            inactiveColor: widget.reader.readDirection == ReadDirection.ltr ? Colors.white : theme.scaffoldBackgroundColor,
                            divisions: _pages.length,
                            onChanged: (double newPage) {
                              setState(() {
                                _pageController.jumpToPage(newPage.toInt());
                              });
                            },
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "${widget.reader.readDirection == ReadDirection.ltr ? _page + 1 : _pages.length - _page} / ${_pages.length}",
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
        child: _isLoaded ? _showReader() : _showLoading(),
      ),
    );
  }

  _initEbook() async {
    _contentElements = widget.reader.convertToObjects();
    _chapter = _contentElements.keys.first;

    double deviceHeight = MediaQuery.of(context).size.height;
    double maxHeight = deviceHeight * 0.8;
    List<List<ContentElement>> pages = [];
    _contentElements.forEach((key, value) {
      value.forEach((key, contentElements) {
        List<double> heights = EbookService.generateHeight(
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

    if (widget.reader.readDirection == ReadDirection.rtl) {
      _pages.addAll(pages.reversed);
    } else {
      _pages.addAll(pages);
    }


    setState((){
      _isLoaded = true;
    });
  }
}