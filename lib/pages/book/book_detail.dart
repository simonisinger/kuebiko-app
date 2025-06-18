import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:image/image.dart' as image;
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';
import 'package:kuebiko_web_client/services/storage/storage.dart';
import 'package:kuebiko_web_client/widget/action_button.dart';
import 'package:kuebiko_web_client/widget/library/download_button.dart';

class BookDetailPage extends StatefulWidget {
  static const route = '/book/detail';
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  State<StatefulWidget> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  image.Image? cover;
  bool _imageLoaded = false;
  bool _ebookDownloaded = false;

  @override
  void initState() {
    super.initState();
    widget.book.cover().then((coverData) {
      setState(() {
        cover = coverData;
        _imageLoaded = true;
      });
    });
    StorageService.service.ebookIsDownloaded(widget.book).then((bool value) {
      setState(() {
        _ebookDownloaded = value;
      });
    });
  }

  Widget _showCover() {
    if (!_imageLoaded) {
      return SpinKitSpinningCircle(
        color: Theme.of(context).shadowColor,
      );
    } else if (cover != null) {
      return Image.memory(cover!.buffer.asUint8List());
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).shadowColor,
          borderRadius: const BorderRadius.all(Radius.circular(12))
        ),
      );
    }
  }

  void _updatePageOnEbookFinished() {
    setState(() {
      _ebookDownloaded = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    return BaseScaffold(
      ListView(
        children: [
          Row(
            children: [
              _showCover(),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.book.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _ebookDownloaded ? ActionButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/book/read', arguments: widget.book);
                            },
                            buttonText: localizations.read
                        ) : DownloadButton(
                          book: widget.book,
                          width: width * 0.9,
                          onFinished: _updatePageOnEbookFinished,
                        ),
                        _ebookDownloaded ? IconButton(
                            onPressed: () async {
                              await StorageService.service.deleteEbook(widget.book);
                              setState(() {
                                _ebookDownloaded = false;
                              });
                            },
                            icon: const Icon(Icons.delete_forever)
                        ) : Container()
                      ],
                    ),
                  ],
                )
              ),
            ],
          )
        ],
      )
    );
  }
}