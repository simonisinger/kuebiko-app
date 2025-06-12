import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/reader/horizontalv3.dart';

import '../../enum/read_direction.dart';

class ReaderOverlayBottom extends StatefulWidget {
  final ReadDirection readDirection;
  final PageController pageController;
  final int countPages;
  const ReaderOverlayBottom({super.key, required this.readDirection, required this.pageController, required this.countPages});

  @override
  State<ReaderOverlayBottom> createState() => _ReaderOverlayBottomState();
}

class _ReaderOverlayBottomState extends State<ReaderOverlayBottom> {
  bool _showMenu = false;
  int _page = 0;

  @override
  void initState() {
    HorizontalV3ReaderPage.pageUpdatedEvent.subscribe(_updatePage);
    HorizontalV3ReaderPage.showMenuChangedEvent.subscribe(_updateShowMenu);
    super.initState();
  }

  _updateShowMenu(Value<bool> value) {
    setState(() {
      _showMenu = value.value;
    });
  }

  _updatePage(Value<int> value) {
    setState (() {
      _page = value.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _showMenu ? Positioned(
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
                    value: widget.pageController.page!,
                    min: 0,
                    max: widget.countPages.toDouble(),
                    activeColor: widget.readDirection == ReadDirection.ltr ? theme.scaffoldBackgroundColor : Colors.white,
                    inactiveColor: widget.readDirection == ReadDirection.ltr ? Colors.white : theme.scaffoldBackgroundColor,
                    divisions: widget.countPages,
                    onChanged: (double newPage) {
                      setState(() {
                        widget.pageController.jumpToPage(newPage.toInt());
                      });
                    },
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "${widget.readDirection == ReadDirection.ltr ? _page + 1 : widget.countPages - _page} / ${widget.countPages}",
                        style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor
                        ),
                      )
                  )
                ]
            )
        )
    ) : Container();
  }

  @override
  void dispose() {
    HorizontalV3ReaderPage.showMenuChangedEvent.unsubscribe(_updateShowMenu);
    HorizontalV3ReaderPage.pageUpdatedEvent.unsubscribe(_updatePage);
    super.dispose();
  }
}
