import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/login/local.dart';
import '../../generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/pages/login/login.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';

class LoginSelectorPage extends StatelessWidget {
  static const String route = '/login-selection';

  const LoginSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BaseScaffold(
      ListView(
        children: [
          ListTile(
            title: Text('Kuebiko-Server'),
            onTap: () => Navigator.of(context).pushNamed(LoginPage.route),
          ),
          ListTile(
            title: Text(localizations.localServer),
            onTap: () => Navigator.of(context).pushNamed(LocalLoginPage.route),
          )
        ],
      )
    );
  }
}
