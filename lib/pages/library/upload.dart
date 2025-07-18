import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/services/di/service_locator.dart';
import 'package:kuebiko_web_client/services/storage/storage.dart';
import 'package:kuebiko_web_client/widget/action_button.dart';

class UploadPage extends StatefulWidget {
  static const route = '/library/upload';
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final List<PlatformFile> _files = [];

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
        _files.addAll(pickedFiles);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    double padding = MediaQuery.of(context).size.width * .1;
    List fileWidgets = _files.map((PlatformFile file) => Container(
      margin: EdgeInsets.symmetric(horizontal: padding),
      child: OutlinedButton(
          onPressed: () {
            setState(() {
              _files.remove(file);
            });
          },
          child: Text(
            file.name
          )
        ),
    )
    ).toList();
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
                        for (PlatformFile file in _files) {
                          ServiceLocator.instance.get<StorageService>().uploadEbook(file);
                        }
                        setState(() {
                          _files.clear();
                          Navigator.of(context).pushNamed('/library');
                        });
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
