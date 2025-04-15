// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get page => 'Seite';

  @override
  String get librariesLoading => 'Bibliotheken werden geladen';

  @override
  String get serverSelection => 'Serverauswahl';

  @override
  String get libraries => 'Bibliotheken';

  @override
  String get noLibraries => 'Dieser Server hat keine Bibliotheken';

  @override
  String get addServer => 'Server hinzufügen';

  @override
  String get createLibrary => 'Bibliothek erstellen';

  @override
  String get library => 'Bibliothek';

  @override
  String get libraryName => 'Bibliotheksname';
}
