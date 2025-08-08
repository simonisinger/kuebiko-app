import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import '../../generated/i18n/app_localizations.dart';
import '../../pages/library/library.dart';
import '../../services/storage/storage.dart';
import '../../widget/action_button.dart';
import '../../widget/library/upload_book.dart';

class UploadPage extends StatefulWidget {
  static const route = '/library/upload';
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final Map<PlatformFile, StreamController<double>> _files = {};
  bool uploadActive = false;

  void _pickFiles() async {
    List<PlatformFile>? pickedFiles = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['epub'],
      withReadStream: true
    ))?.files;

    if (!mounted) return;

    setState(() {
      if (pickedFiles != null) {
        _files.addEntries(pickedFiles.map((file) => MapEntry(file, StreamController())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    double padding = MediaQuery.of(context).size.width * .1;

    return Scaffold(
        body: SafeArea(
            child: Column(
              spacing: 16,
              children: [
                uploadActive ? Container() : Container(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: ActionButton(
                    onPressed: _pickFiles,
                    buttonText: localizations.selectFiles,
                  ),
                ),

                ..._files.keys.map((PlatformFile file) => Container(
                  margin: EdgeInsets.symmetric(horizontal: padding),
                  child: UploadBook(
                    onTap: () {
                      setState(() {
                        _files.remove(file);
                      });
                    },
                    progressStream: _files[file]!.stream,
                    book: file,
                  ),
                )),

                _files.isEmpty ? Container() : Container(
                  margin: EdgeInsets.symmetric(horizontal: padding),
                  child: ActionButton(
                      onPressed: () async {
                        if (!uploadActive) {
                          setState(() {
                            uploadActive = true;
                          });
                          try {
                            for (PlatformFile file in _files.keys) {
                              KuebikoUpload upload = await StorageService
                                  .service
                                  .uploadEbook(file);
                              await _files[file]!.addStream(upload.stream);
                              await _files[file]!.done;
                            }
                            if (context.mounted) {
                              Navigator.of(context).pushNamed(LibraryPage.route);
                            }
                          } catch(exception) {
                            if (context.mounted) {
                              setState(() {
                                uploadActive = false;
                              });
                              ScaffoldMessenger.of (context) .showSnackBar(
                                  SnackBar(content: Text('Error: $exception'))
                              );
                            }
                          }
                        }
                      },
                      buttonText: localizations.upload
                  ),
                )
              ],
            )
        ),
    );
  }
}
