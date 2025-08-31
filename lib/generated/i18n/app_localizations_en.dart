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

  @override
  String get localServer => 'Local';

  @override
  String get name => 'Name';

  @override
  String get createClient => 'Create client';

  @override
  String get deleteOnServer => 'Delete on server';

  @override
  String get cancel => 'Cancel';

  @override
  String get email => 'Email';

  @override
  String get users => 'Users';

  @override
  String get save => 'Save';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordConfirmation => 'Confirm new password';

  @override
  String get usernameEmpty => 'Username cannot be empty';

  @override
  String get emailEmpty => 'Email cannot be empty';

  @override
  String get emailInvalid => 'Email is invalid';

  @override
  String get passwordNotEqual => 'The passwords do not match';

  @override
  String get currentPassword => 'Current password';

  @override
  String get role => 'Role';

  @override
  String get admin => 'Admin';

  @override
  String get user => 'User';

  @override
  String get serverSettings => 'Server settings';

  @override
  String get createAccount => 'Create account';
}
