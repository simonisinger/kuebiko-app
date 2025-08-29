import 'package:flutter/material.dart';
import '../../generated/i18n/app_localizations.dart';
import '../../pages/library/libraries.dart';
import '../../widget/base_scaffold.dart';
import '../../services/client.dart';
import '../../widget/action_button.dart';

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
                  Navigator.of(context).pushNamed(LibrariesPage.route);
                }
              },
              buttonText: AppLocalizations.of(context)!.createLibrary
          ),
          SizedBox(height: 12,),
          OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.cancel)
          )
        ],
      )
    );
  }
}