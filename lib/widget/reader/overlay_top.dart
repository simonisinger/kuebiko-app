import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/reader/horizontalv3.dart';

import '../../pages/reader/content/content_element.dart';

class ReaderOverlayTop extends StatefulWidget {
  final List<List<ContentElement>> pages;
  final Map<String, Map<String, List<ContentElement>>> contentElements;
  const ReaderOverlayTop({super.key, required this.pages, required this.contentElements});

  @override
  State<ReaderOverlayTop> createState() => _ReaderOverlayTopState();
}

class _ReaderOverlayTopState extends State<ReaderOverlayTop> {
  String _chapter = '';
  bool _showMenu = false;

  @override
  void initState() {
    HorizontalV3ReaderPage.pageUpdatedEvent.subscribe(_updateChapter);
    HorizontalV3ReaderPage.showMenuChangedEvent.subscribe(_updateShowMenu);
    super.initState();
    _chapter = widget.contentElements.keys.first;
  }

  void _updateShowMenu(Value<bool> value) {
    setState(() {
      _showMenu = value.value;
    });
  }

  void _updateChapter(Value<int> value) {
    int page = value.value;
    if (widget.pages[page].isNotEmpty) {
      ContentElement targetElement = widget.pages[page].first;
      // iterate through the elements to find the right chapter
      for (String key in widget.contentElements.keys) {
        List<ContentElement> chapterElements = widget.contentElements[key]!.values.reduce((a, b) {
          a.addAll(b);
          return a;
        });
        if (chapterElements.contains(targetElement)) {
          setState(() {
            _chapter = key;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _showMenu ? Positioned(
        top: 0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: theme.primaryColor
          ),
          child: SafeArea(
            bottom: false,
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
          ),
        )
    ) : Container();
  }

  @override
  void dispose() {
    HorizontalV3ReaderPage.showMenuChangedEvent.unsubscribe(_updateShowMenu);
    HorizontalV3ReaderPage.pageUpdatedEvent.unsubscribe(_updateChapter);
    super.dispose();
  }
}
