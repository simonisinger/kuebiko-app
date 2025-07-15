import 'package:kuebiko_web_client/cache/storage.dart';

final class SettingService {
    final String _fontFamilyKey = 'settings.reader.font.family';
    final String _fontSizeKey = 'settings.reader.font.size';
    late String _fontFamily;
    late double _fontSize;

    static Future<SettingService> init() async {
        SettingService service = SettingService();
        service._fontFamily = await storage.read(
            key: service._fontFamilyKey
        ) ?? 'Roboto';
        service._fontSize = double.tryParse(
            (await storage.read(key: service._fontSizeKey)) ?? ''
        ) ?? 14;
        return service;
    }

    double get fontSize => _fontSize;
    String get fontFamily => _fontFamily;

    set fontFamily(String newValue) {
        _fontFamily = newValue;
        storage.write(key: _fontFamilyKey, value: newValue);
    }

    set fontSize(double newValue) {
        _fontSize = newValue;
        storage.write(key: _fontSizeKey, value: newValue.toStringAsFixed(1));
    }
}