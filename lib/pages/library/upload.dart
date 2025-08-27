import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import '../../generated/i18n/app_localizations.dart';
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
  final Map<PlatformFile, StreamController<double>> _fileStreamControllers = {};
  final Map<PlatformFile, Stream<double>> _fileStreams = {};
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
        _fileStreamControllers.addEntries(pickedFiles.map((file) => MapEntry(file, StreamController())));
        _fileStreams.addEntries(pickedFiles.map((file) => MapEntry(file, _fileStreamControllers[file]!.stream.asBroadcastStream())));
      }
    });
  }

  Future<bool> _uploadNextEbook(PlatformFile? lastFile) async {
    List<PlatformFile> keyList = _fileStreamControllers.keys.toList();
    PlatformFile file;

    if (lastFile != null) {
      int index = keyList.indexOf(lastFile);
      if (_fileStreamControllers.keys.last != lastFile) {
        file = keyList[index+1];
      } else {
        return false;
      }
    } else {
      file = keyList.first;
    }

    KuebikoUpload upload = await StorageService
        .service
        .uploadEbook(file);
    StreamController controller = _fileStreamControllers[file]!;
    await controller.addStream(upload.stream);
    return true;
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

                ..._fileStreamControllers.keys.map((PlatformFile file) => Container(
                  margin: EdgeInsets.symmetric(horizontal: padding),
                  child: UploadBook(
                    onFinished: () async {
                      bool uploadStarted = await _uploadNextEbook(file);
                      if (!uploadStarted) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    onTap: () {
                      setState(() {
                        _fileStreamControllers.remove(file);
                        _fileStreams.remove(file);
                      });
                    },
                    progressStream: _fileStreams[file]!,
                    book: file,
                  ),
                )),

               _fileStreamControllers.isEmpty || uploadActive ? Container() : Container(
                  margin: EdgeInsets.symmetric(horizontal: padding),
                  child: ActionButton(
                      onPressed: () async {
                        if (!uploadActive) {
                          setState(() {
                            uploadActive = true;
                          });
                          try {
                            await _uploadNextEbook(null);
                          } catch(exception) {
                            if (context.mounted) {
                              setState(() {
                                uploadActive = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
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
