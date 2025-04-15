import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/client_selection_list.dart';

class ClientSelectionPage extends StatelessWidget {
  const ClientSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width;
    if (MediaQuery.of(context).size.width > 768) {
      width = 768;
    } else {
      width = MediaQuery.of(context).size.width;
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const ClientSelectionListWidget(),
        ),
      ),
    );
  }
}