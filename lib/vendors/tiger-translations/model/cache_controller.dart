import 'package:kuebiko_client/kuebiko_client.dart';

import 'series_cache.dart';

final class TigerTranslationsCacheController implements CacheController {
  final TigerTranslationsSeriesCache _seriesCache;

  TigerTranslationsCacheController(Future<List<Series>> Function() seriesLoader)
      : _seriesCache = TigerTranslationsSeriesCache(seriesLoader);

  @override
  // no library support on tiger translations
  get libraryCache => throw UnimplementedError();

  @override
  get seriesCache => _seriesCache;
}
