import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/services/client.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _generateLibrariesButton(AppLocalizations localizations, BuildContext context) {
    return ClientService.service.selectedClient == null ? Container() : ListTile(
      title: Text(localizations.libraries),
      onTap: () {
        Navigator.of(context).pushNamed('/libraries');
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          ListTile(
            title: Text(localizations.home),
            onTap: () {
              Navigator.of(context).pushNamed('/home');
            },
          ),
          _generateLibrariesButton(localizations, context),
          ListTile(
            title: Text(localizations.serverSelection),
            onTap: () {
              Navigator.of(context).pushNamed('/client-selection');
            },
          ),
        ],
      ),
    );
  }
}