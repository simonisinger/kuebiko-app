import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kuebiko_web_client/services/settings/app.dart';

const FlutterSecureStorage storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true
  ),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock
  )
);

late SettingService settings;

Future<void> setupSettings() async {
  settings = await SettingService.init();
}