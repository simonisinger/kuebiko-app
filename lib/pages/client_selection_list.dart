import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/services/client.dart';

import 'login.dart';

class ClientSelectionListWidget extends StatefulWidget {
  const ClientSelectionListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClientSelectionListWidgetState();
}

class _ClientSelectionListWidgetState extends State<ClientSelectionListWidget> {
  @override
  Widget build(BuildContext context) {

    List<Widget> selectionList = [
      const Padding(
        padding: EdgeInsets.symmetric(
            vertical: 50
        ),
        child: Text(
          'Serverauswahl',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30
          ),
        ),
      ),
    ];
    ClientService.service.clients.forEach((key, value) {
      selectionList.add(
          Row(
              children: [
                Column(
                    children: [
                      Text(key),
                      Text(value.getConfig().baseUrl.toString()),
                    ]
                ),
                IconButton(
                    onPressed: (){
                      setState(() {
                        ClientService.service.removeClient(key);
                      });
                    },
                    icon: const Icon(Icons.close)
                )
              ]
          )
      );
    });

    selectionList.add(
      TextButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()
              )
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.add,
                size: 25,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  'Neuen Eintrag anlegen',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).scaffoldBackgroundColor
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
    return ListView(
      children: selectionList,
    );
  }
}