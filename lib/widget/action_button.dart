import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function() onPressed;
  final IconData? icon;
  final String buttonText;

  const ActionButton({super.key, required this.onPressed, this.icon, required this.buttonText});


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: icon == null ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            icon != null ? Icon(
              Icons.add,
              size: 25,
              color: Theme.of(context).scaffoldBackgroundColor,
            ) : Container(),
            Container(
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).scaffoldBackgroundColor
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}