import 'package:kuebiko_client/kuebiko_client.dart';

import 'series_cache.dart';

final class JNovelClubCacheController implements CacheController {
  final _seriesCache = JNovelClubSeriesCache();

  @override
  // no library support on jnc
  get libraryCache => throw UnimplementedError();

  @override
  get seriesCache => _seriesCache;
}