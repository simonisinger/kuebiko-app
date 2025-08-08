import 'package:flutter/material.dart';
import '../../generated/i18n/app_localizations.dart';
import '../../pages/library/overview.dart';
import '../../services/client.dart';

class ClientSelectionListWidget extends StatefulWidget {
  const ClientSelectionListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ClientSelectionListWidgetState();
}

class _ClientSelectionListWidgetState extends State<ClientSelectionListWidget> {

  @override
  void initState() {
    clientsLoaded.subscribe((_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    List<Widget> selectionList = [
      Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 50
        ),
        child: Text(
          localizations.serverSelection,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 30
          ),
        ),
      ),
    ];
    ClientService.service.clients.forEach((key, value) {
      selectionList.add(
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: OutlinedButton(
              onPressed: () {
                ClientService.service.selectedClient = value;
                Navigator.pushNamed(context, OverviewPage.route);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(key),
                    IconButton(
                        onPressed: (){
                          setState(() {
                            ClientService.service.removeClient(key);
                          });
                        },
                        icon: const Icon(Icons.close)
                    )
                  ]
              ),
            ),
          )
      );
    });

    return ListView(
      children: selectionList,
    );
  }
}