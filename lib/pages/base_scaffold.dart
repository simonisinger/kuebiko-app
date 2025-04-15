import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/widget/main_drawer.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  const BaseScaffold(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: const MainDrawer(),
      body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: child,
      ),
    );
  }
}