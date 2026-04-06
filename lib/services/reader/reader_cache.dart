import 'dart:convert';

import 'package:kuebiko_client/kuebiko_client.dart';

import '../../cache/storage.dart';
import '../client.dart';

class ReaderCacheService {
  static const readerCacheKey = 'pageConfigList';


  Future<void> write(Book book, List pages) async {
    String configKey = _generateCacheConfigKey(book);
    await storage.write(
        key: configKey,
        value: jsonEncode({
          'fontSize': settings.fontSize,
          'fontFamily': settings.fontFamily,
          'pageMapping': pages.map((element) => element.length).toList()
        })
    );
    List pageConfigKeys = jsonDecode(await storage.read(key: readerCacheKey) ?? '[]');
    if (!pageConfigKeys.contains(configKey)) {
      pageConfigKeys.add(configKey);
      await storage.write(key: readerCacheKey, value: jsonEncode(pageConfigKeys));
    }
  }

  Future<void> clear() async {
    List renderCacheKeys = jsonDecode(await storage.read(key: readerCacheKey) ?? '[]');
    for (String key in renderCacheKeys) {
      await storage.delete(key: key);
    }
    await storage.write(key: readerCacheKey, value: '[]');
  }

  String _generateCacheConfigKey(Book book) => '${ClientService.service.getCurrentLocalName()}-${book.id}-pageconfig';

  Future<bool> has(Book book) async {
    List pageConfigKeys = jsonDecode(await storage.read(key: ReaderCacheService.readerCacheKey) ?? '[]');
    String configKey = _generateCacheConfigKey(book);
    return pageConfigKeys.contains(configKey);
  }

  Future<Map<String, dynamic>?> get(Book book) async {
    String configKey = _generateCacheConfigKey(book);
    String? configRaw = await storage.read(key: configKey);
    if (configRaw == null) {
      return null;
    }
    return jsonDecode(configRaw);
  }
}