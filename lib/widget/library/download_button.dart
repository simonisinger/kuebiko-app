import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/services/storage/storage.dart';

class DownloadButton extends StatefulWidget {
  final double width;
  final double height;
  final Book book;
  final Function()? onFinished;

  const DownloadButton({
    super.key,
    required this.book,
    this.onFinished,
    this.width = 200.0,
    this.height = 50.0,
  });

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  Stream<double>? progressStream;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return StreamBuilder<double>(
      stream: progressStream,
      initialData: 0.0,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0.0;

        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Stack(
              children: [
                Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),

                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(widget.height / 2),
                    ),
                  ),
                ),

                SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        progressStream = StorageService.service.downloadEbook(widget.book).asBroadcastStream();
                      });
                      progressStream?.listen((data){
                        if (data >= 1.0 && widget.onFinished != null) {
                          widget.onFinished!();
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${localizations.download} ${(progress * 100).toInt()}%',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        ClipRect(
                          clipper: _ProgressClipper(progress),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${localizations.download} ${(progress * 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.white, // oder eine andere Kontrastfarbe
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Clipper um den Text entsprechend des Fortschritts zu clippen
class _ProgressClipper extends CustomClipper<Rect> {
  final double progress;
  
  _ProgressClipper(this.progress);
  
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * progress, size.height);
  }
  
  @override
  bool shouldReclip(_ProgressClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}