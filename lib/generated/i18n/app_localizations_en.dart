// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get page => 'Page';

  @override
  String get librariesLoading => 'Libraries are loading';

  @override
  String get serverSelection => 'Server selection';

  @override
  String get libraries => 'Libraries';

  @override
  String get noLibraries => 'This server has no libraries';

  @override
  String get addServer => 'Add Server';

  @override
  String get createLibrary => 'Create library';

  @override
  String get library => 'Library';

  @override
  String get libraryName => 'Library name';

  @override
  String get selectFiles => 'Select files';

  @override
  String get upload => 'Upload';

  @override
  String get read => 'Read';

  @override
  String get home => 'Home';

  @override
  String get download => 'Download';

  @override
  String get downloading => 'Downloading';

  @override
  String get continueRead => 'Continue';

  @override
  String get readAgain => 'Read again';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get fontSize => 'Font size';

  @override
  String get fontFamily => 'Font family';

  @override
  String selectedFontFamily(Object fontFamily) {
    return 'Selected font family: $fontFamily';
  }

  @override
  String get settings => 'Settings';

  @override
  String get preview => 'Preview';

  @override
  String get previewText => 'This is a preview';

  @override
  String get clearRenderCache => 'Clear render cache';

  @override
  String get reader => 'Reader';

  @override
  String volume(Object volNumber) {
    return 'Vol. $volNumber';
  }

  @override
  String get licenses => 'Licenses';
}
