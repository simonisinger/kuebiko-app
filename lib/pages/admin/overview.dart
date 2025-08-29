import 'package:flutter/material.dart';
import '../../generated/i18n/app_localizations.dart';

import 'user/list.dart';
import '../../services/client.dart';
import '../../widget/base_scaffold.dart';

class AdminSettingsOverview extends StatelessWidget {
  static const String route = '/admin';

  const AdminSettingsOverview({super.key});

  List<Widget> _generateButtons(BuildContext context) {
    List<Widget> widgets = [];
    AppLocalizations localizations = AppLocalizations.of(context)!;
    if (ClientService.service.clientHasFeature(ClientFeature.userManagement)) {
      widgets.add(ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(AdminUserListPage.route);
        },
        title: Text(localizations.users),
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) => BaseScaffold(
    SingleChildScrollView(
      child: Column(
        children: _generateButtons(context),
      ),
    ),
  );
}
