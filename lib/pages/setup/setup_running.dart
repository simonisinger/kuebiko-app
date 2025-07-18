import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SetupRunningPage extends StatelessWidget {
  final String message;
  const SetupRunningPage(this.message, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: SpinKitDualRing(
                    color: Theme.of(context).shadowColor,
                    size: 100,
                  ),
                ),
              ),
              Positioned.fill(
                  child: Container(
                      margin: const EdgeInsets.only(top: 200),
                      alignment: AlignmentDirectional.center,
                      child: const Text(
                        'Installation wird auf dem Server ausgeführt',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  )
              )
            ]
        ),
      ),
    );
  }
}
