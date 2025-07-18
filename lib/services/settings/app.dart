import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SettingService {
    final String _fontFamilyKey = 'settings.reader.font.family';
    final String _fontSizeKey = 'settings.reader.font.size';
    late String _fontFamily;
    late double _fontSize;
    final FlutterSecureStorage _storage;

    SettingService(this._storage);

    static Future<SettingService> init() async {
        // This is kept for backward compatibility
        // In production code, you would use the ServiceLocator to get the storage instance
        final storage = FlutterSecureStorage(
            aOptions: const AndroidOptions(
                encryptedSharedPreferences: true
            ),
            iOptions: const IOSOptions(
                accessibility: KeychainAccessibility.first_unlock
            )
        );

        SettingService service = SettingService(storage);
        await service._loadSettings();
        return service;
    }

    Future<void> _loadSettings() async {
        _fontFamily = await _storage.read(
            key: _fontFamilyKey
        ) ?? 'Roboto';
        _fontSize = double.tryParse(
            (await _storage.read(key: _fontSizeKey)) ?? ''
        ) ?? 14;
    }

    double get fontSize => _fontSize;
    String get fontFamily => _fontFamily;

    set fontFamily(String newValue) {
        _fontFamily = newValue;
        _storage.write(key: _fontFamilyKey, value: newValue);
    }

    set fontSize(double newValue) {
        _fontSize = newValue;
        _storage.write(key: _fontSizeKey, value: newValue.toStringAsFixed(1));
    }
}
