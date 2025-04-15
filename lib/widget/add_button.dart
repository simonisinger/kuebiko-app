import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/widget/action_button.dart';

class AddWidget extends StatelessWidget {
  final String targetPath;
  final String buttonText;
  const AddWidget({super.key, required this.targetPath, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(targetPath);
        },
        icon: Icons.add,
        buttonText: buttonText
    );
  }
}