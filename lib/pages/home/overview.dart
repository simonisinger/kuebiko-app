import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/pages/client_selection.dart';
import 'package:kuebiko_web_client/pages/home/books_list_horizontal.dart';
import 'package:kuebiko_web_client/services/client.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<Book>? reading;
  List<Book>? unread;
  List<Book>? finished;

  @override
  void initState() {
    super.initState();
    ClientService.service.selectedClient!.currentUser().then((User user) {
      user.unreadBooks().then((value){
        unread = value;
      });
      user.readingBooks().then((value){
        reading = value;
      });
      user.finishedBooks().then((value){
        finished = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
              ),
              child: const Text('Kuebiko'),
            ),
            ListTile(
              title: const Text('Serverauswahl'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const ClientSelectionPage()
                    )
                );
              },
            ),
            ListTile(
              title: const Text('Übersicht'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const OverviewPage()
                    )
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
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
          reading == null ? SpinKitFadingCircle() : BookListHorizontalWidget(books: reading!),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Vorschläge',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          unread == null ? SpinKitFadingCircle() : BookListHorizontalWidget(books: unread!),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Nochmal lesen',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          finished == null ? SpinKitFadingCircle() : BookListHorizontalWidget(books: finished!),
        ],
      ),
    );
  }
}
