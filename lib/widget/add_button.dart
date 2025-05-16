import 'package:flutter/material.dart';

class AddWidget extends StatelessWidget {
  final String targetPath;
  const AddWidget({super.key, required this.targetPath});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(targetPath);
        },
        child: const Icon(Icons.add),
    );
  }
}