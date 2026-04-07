import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/services/client.dart';

class JNovelClubSeriesCache implements SeriesCache {
  final List<Series> _elements = [];
  @override
  List<Series> getAll() => _elements;

  @override
  Future<Series> getById(String id) async {
    try {
      return _elements.firstWhere((element) => element.id == id);
    }catch (e){
      await update();
      return _elements.firstWhere((element) => element.id == id);
    }
  }

  @override
  Future<void> update() async {
    List<Series> series = await (ClientService.service.selectedClient as KuebikoClient).getAllSeries();
    for (Series seriesSingle in series) {
      try {
        _elements.firstWhere((Series element) => element.id == seriesSingle.id);
      } catch (e) {
        _elements.add(seriesSingle);
      }
    }
  }
}