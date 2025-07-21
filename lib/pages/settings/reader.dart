import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuebiko_web_client/cache/storage.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';

import '../../widget/base_scaffold.dart';

final class ReaderSettingsPage extends StatefulWidget {
  static const String route = '/settings/reader';

  const ReaderSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReaderSettingsPageState();
}

final class _ReaderSettingsPageState extends State<ReaderSettingsPage> {
  List<String> fontSearchResults = [];

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    Map<String, dynamic> fonts = GoogleFonts.asMap();
    TextTheme textTheme = Theme.of(context).textTheme;
    return BaseScaffold(
      Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () {},
                child: Text(localizations.clearRenderCache)
            ),
          ),
          Text(
            localizations.fontSize,
            style: textTheme.titleLarge,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      settings.fontSize = settings.fontSize -= 1;
                    });
                  },
                  icon: Icon(Icons.exposure_minus_1)
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      settings.fontSize = settings.fontSize -= 0.1;
                    });
                  },
                  icon: Icon(Icons.remove)
              ),
              Text(settings.fontSize.toStringAsFixed(1)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      settings.fontSize = settings.fontSize += 0.1;
                    });
                  },
                  icon: Icon(Icons.add)
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      settings.fontSize = settings.fontSize += 1;
                    });
                  },
                  icon: Icon(Icons.plus_one)
              ),
            ],
          ),
          Text(
            localizations.fontFamily,
            style: textTheme.titleLarge,
          ),
          Text(
            localizations.selectedFontFamily(settings.fontFamily),
            style: textTheme.bodyLarge,
          ),
          TextField(
            onSubmitted: (String value) {
              List<String> searchResults = [];
              if (value.length > 2) {
                setState(() {
                  searchResults = fonts
                      .keys
                      .where((font) => font.contains(value))
                      .toList();
                });
              }
              setState(() {
                fontSearchResults = searchResults;
              });
            },
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: fontSearchResults.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      settings.fontFamily = fontSearchResults[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      fontSearchResults[index],
                      style: textTheme.bodyLarge,
                    ),
                  ),
                );
              }
          ),
          Text(
            textAlign: TextAlign.start,
            localizations.preview,
            style: textTheme.titleLarge,
          ),
          Text(
            localizations.previewText,
            style: textTheme.bodyMedium!.copyWith(
              fontSize: settings.fontSize,
              fontFamily: settings.fontFamily
            ),
          ),
        ],
      ),
    );
  }
}
