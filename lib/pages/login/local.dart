import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/pages/client_selection.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';

class LocalLoginPage extends StatefulWidget {
  static const route = '/login/local';
  const LocalLoginPage({super.key});

  @override
  State<LocalLoginPage> createState() => _LocalLoginPageState();
}

class _LocalLoginPageState extends State<LocalLoginPage> {
  final TextEditingController _localClientName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BaseScaffold(
      Column(
        children: [
          TextField(
            controller: _localClientName,
            decoration: InputDecoration(
              hintText: localizations.name,
              labelText: localizations.name
            ),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () async {
                  await ClientService.service.addLocalClient(_localClientName.text);
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(ClientSelectionPage.route);
                  }
                },
                child: Text(localizations.createClient),
            ),
          )
        ],
      )
    );
  }
}
