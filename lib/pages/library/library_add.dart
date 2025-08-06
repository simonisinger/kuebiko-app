import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/widget/action_button.dart';

class LibraryAddPage extends StatelessWidget {
  static const route = '/library/add';
  final TextEditingController _libraryName = TextEditingController();
  LibraryAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BaseScaffold(
      ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: TextField(
              controller: _libraryName,
              decoration: InputDecoration(
                hintText: localizations.libraryName,
                labelText: localizations.libraryName
              ),
            ),
          ),
          ActionButton(
              onPressed: () async {
                await ClientService.service
                    .selectedClient!
                    .createLibrary(_libraryName.text, '/${_libraryName.text}');
                if (context.mounted) {
                  Navigator.of(context).pushNamed('/libraries');
                }
              },
              buttonText: AppLocalizations.of(context)!.createLibrary
          )
        ],
      )
    );
  }
}