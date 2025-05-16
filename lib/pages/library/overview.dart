import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';

import '../../widget/library/books_list_horizontal.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);
  static const String route = '/home';

  @override
  State<StatefulWidget> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late List<Book> _reading;
  bool _readingInitialized = false;
  late List<Book> _unread;
  bool _unreadInitialized = false;
  late List<Book> _finished;
  bool _finishedInitialized = false;

  @override
  void initState() {
    super.initState();
    ClientService.service.selectedClient!.currentUser().then((User user) {
      user.unreadBooks().then((value) {
        setState(() {
          _unread = value;
          _unreadInitialized = true;
        });
      });
      user.readingBooks().then((value) {
        setState(() {
          _reading = value;
          _readingInitialized = true;
        });
      });
      user.finishedBooks().then((value) {
        setState(() {
          _finished = value;
          _finishedInitialized = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Weiterlesen',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          !_readingInitialized ? SpinKitFadingCircle(
            color: Theme.of(context).shadowColor,
          ) : BookListHorizontalWidget(books: _reading),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Vorschläge',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          !_unreadInitialized ? SpinKitFadingCircle(
            color: Theme.of(context).shadowColor,
          ) : BookListHorizontalWidget(books: _unread),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Nochmal lesen',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          !_finishedInitialized ? SpinKitFadingCircle(
            color: Theme.of(context).shadowColor,
          ) : BookListHorizontalWidget(books: _finished),
        ],
      ),
    );
  }
}
