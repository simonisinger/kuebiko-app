import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/admin/overview.dart';
import 'package:kuebiko_web_client/pages/library/libraries.dart';
import '../generated/i18n/app_localizations.dart';
import '../pages/client_selection.dart';
import '../pages/library/overview.dart';
import '../services/client.dart';

import '../pages/settings/overview.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _generateLibrariesButton(AppLocalizations localizations, BuildContext context) {
    return ClientService.service.selectedClient == null
        || !ClientService.service.clientHasFeature(ClientFeature.libraries) ? Container() : ListTile(
      leading: Icon(Icons.my_library_books),
      title: Text(localizations.libraries),
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(LibrariesPage.route, (_) => false);
      },
    );
  }

  Widget _generateHomeButton(AppLocalizations localizations, BuildContext context) {
    return ClientService.service.selectedClient == null ? Container() : ListTile(
      leading: Icon(Icons.home),
      title: Text(localizations.home),
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          OverviewPage.route,
              (_) => false,
        );
      },
    );
  }
  
  Future<Widget> _generateServerSettingsButton(AppLocalizations localizations, BuildContext context) async {
    return ClientService.service.selectedClient == null
        || !ClientService.service.clientHasFeature(ClientFeature.libraries)
        || !(await ClientService.service.selectedClient!.currentUser()).roles.contains('Admin') ? Container() : ListTile(
      leading: Icon(Icons.my_library_books),
      title: Text(localizations.serverSettings),
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(AdminSettingsOverview.route, (_) => false);
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
          _generateHomeButton(localizations, context),
          _generateLibrariesButton(localizations, context),
          FutureBuilder(
              future: _generateServerSettingsButton(localizations, context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return Container();
                }
              }
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text(localizations.serverSelection),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  ClientSelectionPage.route,
                  (_) => false
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(localizations.settings),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  OverviewSettingsPage.route,
                  (_) => false
              );
            },
          )
        ],
      ),
    );
  }
}