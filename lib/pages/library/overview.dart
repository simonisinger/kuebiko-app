import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';

import '../../widget/library/books_list_horizontal.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});
  static const String route = '/home';

  @override
  State<StatefulWidget> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {

  Widget _rebuildFutureBuilder(BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.active:
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.done:
        if (snapshot.hasData) {
          return BookListHorizontalWidget(books: snapshot.data!);
        } else {
          return Text(snapshot.error.toString());
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BaseScaffold(
      FutureBuilder(
          future: ClientService.service.selectedClient!.currentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        localizations.continueRead,
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: snapshot.data!.readingBooks(),
                        builder: _rebuildFutureBuilder
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        localizations.suggestions,
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: snapshot.data!.unreadBooks(),
                        builder: _rebuildFutureBuilder
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        localizations.readAgain,
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: snapshot.data!.finishedBooks(),
                        builder: _rebuildFutureBuilder
                    )
                  ],
                );
              } else {
                return Text(snapshot.error.toString());
              }
            } else {
              return CircularProgressIndicator();
            }
          }
      ),
    );
  }
}
