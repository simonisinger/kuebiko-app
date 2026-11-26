import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

import '../../services/client.dart';
import '../../widget/base_scaffold.dart';
import 'detail.dart';

class SeriesOverviewPage extends StatelessWidget {
  static const route = '/series';

  const SeriesOverviewPage({super.key});

  Future<List<Series>> _loadSeries() {
    ClientService service = ClientService.service;
    // clients without library support (e.g. tiger translations) provide series directly
    Library? library = service.selectedLibrary;
    if (library != null && service.clientHasFeature(ClientFeature.libraries)) {
      return library.series();
    }
    return service.selectedClient!.getAllSeries();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      FutureBuilder<List<Series>>(
        future: _loadSeries(),
        builder: (BuildContext context, AsyncSnapshot<List<Series>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator(color: Theme.of(context).shadowColor));
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          List<Series> series = snapshot.data!;
          return ListView.builder(
            itemCount: series.length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              title: Text(series[index].name),
              onTap: () {
                Navigator.of(context).pushNamed(
                  SeriesViewPage.route,
                  arguments: series[index]
                );
              },
            ),
          );
        },
      ),
    );
  }
}
