import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/widget/add_button.dart';
import 'package:kuebiko_web_client/widget/main_drawer.dart';

class LibrariesPage extends StatefulWidget {
  const LibrariesPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: const MainDrawer(),
      body: initialized ? _showLibraries() : _showLoading(),
    );
  }

  Widget _showLibraries() {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    List<Widget> widgets = [];
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
    widgets.addAll(
        libraries.map((Library element) => OutlinedButton(
            onPressed: () {
              ClientService.service.selectedLibrary = element;
              Navigator.of(context).pushNamed('/library');
            },
            child: Text(element.name)
        ))
    );
    widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: AddWidget(
            targetPath: '/library/add',
            buttonText: localizations.createLibrary,
          ),
        )
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
          children: widgets,
      ),
    );
  }

  Widget _showLoading() => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDualRing(
              color: Theme.of(context).shadowColor,
              size: 100,
            ),
            Container(
                margin: const EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context)!.librariesLoading)
            )
          ],
        ),
      );
}
