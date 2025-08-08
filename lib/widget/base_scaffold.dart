import 'package:flutter/material.dart';
import '../widget/main_drawer.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;
  const BaseScaffold(this.child, {super.key, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: const MainDrawer(),
      floatingActionButton: floatingActionButton,
      body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: child,
      ),
    );
  }
}