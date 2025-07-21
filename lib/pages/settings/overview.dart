import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/pages/settings/reader.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';

class OverviewSettingsPage extends StatelessWidget {
  const OverviewSettingsPage({super.key});
  static const route = '/settings';

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BaseScaffold(
      ListView(
        children: [
          ListTile(
            title: Text(localizations.reader),
            onTap: () {
              Navigator.of(context).pushNamed(ReaderSettingsPage.route);
            },
          ),
          ListTile(
            title: Text(localizations.licenses),
            onTap: () {
              showLicensePage(context: context);
            },
          )
        ],
      )
    );
  }
}
