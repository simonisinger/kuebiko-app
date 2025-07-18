import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/reader/horizontalv3.dart';
import 'package:provider/provider.dart';

import '../../pages/reader/content/content_element.dart';

class ReaderOverlayTop extends StatefulWidget {
  final List<List<ContentElement>> pages;
  final Map<String, Map<String, List<ContentElement>>> contentElements;
  const ReaderOverlayTop({super.key, required this.pages, required this.contentElements});

  @override
  State<ReaderOverlayTop> createState() => _ReaderOverlayTopState();
}

class _ReaderOverlayTopState extends State<ReaderOverlayTop> {

  @override
  void initState() {
    context.watch<ReaderChanges>();
    super.initState();
  }

  String _updateChapter(int page) {
    String chapter = widget.contentElements.keys.first;
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
            chapter = key;
          });
          break;
        }
      }
    }
    return chapter;
  }

  @override
  Widget build(BuildContext context) {
    ReaderChanges readerChanges = context.read<ReaderChanges>();
    String chapter = _updateChapter(readerChanges.page);
    bool showMenu = readerChanges.showMenu;

    final ThemeData theme = Theme.of(context);
    return showMenu ? Positioned(
        top: 0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
              color: theme.primaryColor
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: Icon(
                          Icons.close,
                          color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                Text(
                  chapter,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).scaffoldBackgroundColor)
                ),
              ],
            ),
          ),
        )
    ) : Container();
  }
}
