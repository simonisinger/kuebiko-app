import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';
import 'package:kuebiko_web_client/services/storage/storage.dart';
import 'package:kuebiko_web_client/widget/action_button.dart';
import 'package:kuebiko_web_client/widget/book/download_button.dart';

class BookDetailPage extends StatefulWidget {
  static const route = '/book/detail';
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  State<StatefulWidget> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  Uint8List? cover;
  bool _ebookDownloaded = false;

  @override
  void initState() {
    super.initState();
    
    StorageService.service.ebookIsDownloaded(widget.book).then((bool value) {
      setState(() {
        _ebookDownloaded = value;
      });
    });
  }

  Widget _showCover() {
    return FutureBuilder(
      future: StorageService.service.getCover(widget.book),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.memory(
              snapshot.data,
              width: MediaQuery.of(context).size.width * .1,
          );
        } else {
          return SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator()
          );
        }
      }
    );
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
          _showCover(),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.book.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _ebookDownloaded ? Flexible(
                              child: ActionButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/book/read', arguments: widget.book);
                                },
                                buttonText: localizations.read
                              )
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