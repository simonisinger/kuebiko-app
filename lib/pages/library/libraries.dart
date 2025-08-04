import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/widget/add_button.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';

class LibrariesPage extends StatefulWidget {
  const LibrariesPage({super.key});
  static const String route = '/libraries';

  @override
  State<StatefulWidget> createState() => _LibrariesPageState();
}

class _LibrariesPageState extends State<LibrariesPage> {

  late final List<Library> libraries;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    if (ClientService.service.selectedClient != null) {
      ClientService.service.selectedClient!.getLibraries().then((libs) {
        setState(() {
          libraries = libs;
          initialized = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      initialized ? _showLibraries() : _showLoading(),
      floatingActionButton: const AddWidget(
        targetPath: '/library/add',
      ),
    );
  }

  Widget _showLibraries() {
    List<Widget> widgets = [];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
              future: ClientService.service.selectedClient!.getLibraries(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasData) {

                      if (libraries.isEmpty) {
                        widgets.add(
                            SizedBox(
                                width: double.infinity,
                                child: Text(
                                  AppLocalizations.of(context)!.noLibraries,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            )
                        );
                      }

                      return ListView(children: snapshot.data!.map((Library element) => OutlinedButton(
                          onPressed: () {
                            ClientService.service.selectedLibrary = element;
                            Navigator.of(context).pushNamed('/library');
                          },
                          child: Text(element.name)
                      )).toList());
                    } else {
                      return Text(snapshot.error.toString());
                    }
                }
              },
      ),
    );
  }

  Widget _showLoading() => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Container(
                margin: const EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context)!.librariesLoading)
            )
          ],
        ),
      );
}
