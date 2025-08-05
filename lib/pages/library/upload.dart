import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/pages/library/library.dart';
import 'package:kuebiko_web_client/services/storage/storage.dart';
import 'package:kuebiko_web_client/widget/action_button.dart';
import 'package:kuebiko_web_client/widget/library/upload_book.dart';

class UploadPage extends StatefulWidget {
  static const route = '/library/upload';
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final Map<PlatformFile, StreamController<double>> _files = {};

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

    List fileWidgets = _files.keys.map((PlatformFile file) => Container(
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
      )).toList();
    return Scaffold(
        body: SafeArea(
            child: Column(
              spacing: 16,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: ActionButton(
                    onPressed: _pickFiles,
                    buttonText: localizations.selectFiles,
                  ),
                ),
                ...fileWidgets,
                _files.isEmpty ? Container() : Container(
                  margin: EdgeInsets.symmetric(horizontal: padding),
                  child: ActionButton(
                      onPressed: () async {
                        for (PlatformFile file in _files.keys) {
                          KuebikoUpload upload = await StorageService.service.uploadEbook(file);
                          await _files[file]!.addStream(upload.stream);
                          await _files[file]!.done;
                        }
                        if (context.mounted) {
                          Navigator.of(context).pushNamed(LibraryPage.route);
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
