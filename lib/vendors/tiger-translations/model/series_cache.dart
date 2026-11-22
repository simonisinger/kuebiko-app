import 'package:kuebiko_client/kuebiko_client.dart';

class TigerTranslationsSeriesCache implements SeriesCache {
  final Future<List<Series>> Function() _loader;
  final List<Series> _elements = [];

  TigerTranslationsSeriesCache(this._loader);

  @override
  List<Series> getAll() => _elements;

  @override
  Future<Series> getById(String id) async {
    try {
      return _elements.firstWhere((element) => element.id == id);
    } catch (e) {
      await update();
      return _elements.firstWhere((element) => element.id == id);
    }
  }

  @override
  Future<void> update() async {
    List<Series> series = await _loader();
    for (Series seriesSingle in series) {
      if (!_elements.any((Series element) => element.id == seriesSingle.id)) {
        _elements.add(seriesSingle);
      }
    }
  }
}
