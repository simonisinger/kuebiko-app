import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/client_selection_list.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';

import '../widget/add_button.dart';

class ClientSelectionPage extends StatelessWidget {
  const ClientSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width;
    if (MediaQuery.of(context).size.width > 768) {
      width = 768;
    } else {
      width = MediaQuery.of(context).size.width;
    }

    return BaseScaffold(
      floatingActionButton: const AddWidget(targetPath: '/login'),
      Container(
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