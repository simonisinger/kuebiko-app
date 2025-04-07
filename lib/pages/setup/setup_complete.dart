import 'package:flutter/material.dart';

class SetupCompletePage extends StatelessWidget {
  const SetupCompletePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 10),
            (){
          Navigator.pushReplacementNamed(context, '/');
        }
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 100,
                  )
                ),
              ),
              Positioned.fill(
                  child: Container(
                      margin: const EdgeInsets.only(top: 200),
                      alignment: AlignmentDirectional.center,
                      child: const Text(
                        'Installation wurde erfolgreich abgeschlossen',
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
