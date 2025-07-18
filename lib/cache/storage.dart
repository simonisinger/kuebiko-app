import 'package:kuebiko_web_client/services/settings/app.dart';

late SettingService settings;

Future<void> setupSettings() async {
  settings = await SettingService.init();
}