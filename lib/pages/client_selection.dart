import 'package:flutter/material.dart';
import '../../pages/client_selection_list.dart';
import '../../pages/login/login_selector.dart';
import '../../widget/base_scaffold.dart';

import '../widget/add_button.dart';

class ClientSelectionPage extends StatelessWidget {
  static const String route = '/client-selection';
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
      floatingActionButton: const AddWidget(targetPath: LoginSelectorPage.route),
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