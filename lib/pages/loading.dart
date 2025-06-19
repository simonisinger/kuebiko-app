import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_web_client/services/client.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    clientsLoaded.subscribe(_jumpToSelection);
    super.initState();
  }

  void _jumpToSelection(_) {
    Navigator.pushReplacementNamed(context, '/client-selection');
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: Container(
          decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .scaffoldBackgroundColor
          ),
          child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: SpinKitDualRing(
                      color: Theme
                          .of(context)
                          .shadowColor,
                      size: 100,
                    ),
                  ),
                ),
                Positioned.fill(
                    child: Container(
                        margin: const EdgeInsets.only(top: 200),
                        alignment: AlignmentDirectional.center,
                        child: const Text(
                          'Kuebiko startet. Einen Moment bitte',
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