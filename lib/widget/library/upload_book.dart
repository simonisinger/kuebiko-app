import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class   UploadBook extends StatefulWidget {
  final double width;
  final double height;
  final PlatformFile book;
  final Stream<double> progressStream;
  final Function()? onTap;
  final Function()? onFinished;

  const UploadBook({
    super.key,
    required this.book,
    required this.progressStream,
    this.onTap,
    this.onFinished,
    this.width = 400.0,
    this.height = 50.0,
  });

  @override
  State<UploadBook> createState() => _UploadBookState();
}

class _UploadBookState extends State<UploadBook> {

  @override
  void initState() {
    widget.progressStream.listen((data) {
      if (data >= 1.0 && widget.onFinished != null) {
        widget.onFinished!();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<double>(
      stream: widget.progressStream,
      initialData: 0.0,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0.0;
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.height / 2),
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
                      if (widget.onTap != null) {
                        widget.onTap!();
                      }
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
                            snapshot.connectionState == ConnectionState.none
                                ? widget.book.name
                                : '${widget.book.name} ${(progress).toInt()}%',
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
                              '${widget.book.name} ${(progress).toInt()}%',
                              style: TextStyle(
                                color: Theme.of(context).scaffoldBackgroundColor,
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