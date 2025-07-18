import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/reader/horizontalv3.dart';
import 'package:provider/provider.dart';

import '../../enum/read_direction.dart';

class ReaderOverlayBottom extends StatefulWidget {
  final ReadDirection readDirection;
  final PageController pageController;
  final int countPages;
  const ReaderOverlayBottom({
    super.key,
    required this.readDirection,
    required this.pageController,
    required this.countPages
  });

  @override
  State<ReaderOverlayBottom> createState() => _ReaderOverlayBottomState();
}

class _ReaderOverlayBottomState extends State<ReaderOverlayBottom> {

  @override
  void initState() {
    context.watch<ReaderChanges>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ReaderChanges readerChanges = context.read<ReaderChanges>();
    final page = readerChanges.page;
    final bool showMenu = readerChanges.showMenu;

    final ThemeData theme = Theme.of(context);
    return showMenu ? Positioned(
        bottom: 0,
        width: MediaQuery.of(context).size.width,
        child: Container(
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            decoration: BoxDecoration(
                color: theme.primaryColor
            ),
            child: SafeArea(
              top: false,
              child: Column(
                  children: [
                    Slider(
                      value: page.toDouble(),
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
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "${widget.readDirection == ReadDirection.ltr ? page + 1 : widget.countPages - page} / ${widget.countPages}",
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor
                          ),
                        )
                    )
                  ]
              ),
            )
        )
    ) : Container();
  }
}
