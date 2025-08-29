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

  @override
  String get selectFiles => 'Dateien auswählen';

  @override
  String get upload => 'Hochladen';

  @override
  String get read => 'Lesen';

  @override
  String get home => 'Startseite';

  @override
  String get download => 'Herunterladen';

  @override
  String get downloading => 'Lädt herunter';

  @override
  String get continueRead => 'Weiterlesen';

  @override
  String get readAgain => 'Nochmal lesen';

  @override
  String get suggestions => 'Verschläge';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get fontFamily => 'Schriftart';

  @override
  String selectedFontFamily(Object fontFamily) {
    return 'Ausgewählte Schriftart: $fontFamily';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get preview => 'Vorschau';

  @override
  String get previewText => 'Das ist eine Vorschau';

  @override
  String get clearRenderCache => 'Rendercache leeren';

  @override
  String get reader => 'Reader';

  @override
  String volume(Object volNumber) {
    return 'Bd. $volNumber';
  }

  @override
  String get licenses => 'Lizenzen';

  @override
  String get localServer => 'Lokal';

  @override
  String get name => 'Name';

  @override
  String get createClient => 'Client erstellen';

  @override
  String get deleteOnServer => 'Auf dem Server löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get email => 'E-Mail';

  @override
  String get users => 'Benutzer';

  @override
  String get save => 'Speichern';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get newPasswordConfirmation => 'Neues Passwort bestätigen';

  @override
  String get usernameEmpty => 'Benutzername darf nicht leer sein';

  @override
  String get emailEmpty => 'E-Mail darf nicht leer sein';

  @override
  String get emailInvalid => 'Die eingegebene E-Mail ist ungültig';
}
