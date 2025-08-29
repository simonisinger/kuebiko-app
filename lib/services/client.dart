import 'dart:convert';
import 'dart:io';

import 'package:event/event.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import '../../cache/storage.dart';
import '../../vendors/local/model/client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:version/version.dart';

enum ClientFeature {
  deleteOnServer,
  downloadEbooks,
  userManagement,
  serverSettings,
  series,
  uploadEbooks,
  libraries,
  progressCache,
  librariesCache,
  ebooksCache,
  seriesCache,
  ebookMetadataCache
}

Event clientsLoaded = Event();
class ClientService {
  static final ClientService service = ClientService();
  final Map<String, Client> _clients = {};
  Client? selectedClient;
  Library? selectedLibrary;

  ClientService() {
    _initClients();
  }

  final Map<Type, Set<Enum>> featureSet = {
    KuebikoClient: {
      ClientFeature.deleteOnServer,
      ClientFeature.downloadEbooks,
      ClientFeature.serverSettings,
      ClientFeature.series,
      ClientFeature.uploadEbooks,
      ClientFeature.libraries,
      ClientFeature.progressCache,
      ClientFeature.librariesCache,
      ClientFeature.ebooksCache,
      ClientFeature.seriesCache,
      ClientFeature.userManagement
    },
    LocalClient: {
      ClientFeature.series,
      ClientFeature.uploadEbooks,
      ClientFeature.libraries,
      ClientFeature.progressCache,
    }
  };

  final String _clientIndexKey = 'localNames';

  bool clientHasFeature(ClientFeature feature)
    => featureSet[selectedClient.runtimeType]!.contains(feature);

  Future<List<String>> _loadLocalNames() async {
    String? rawHostsJson = await storage.read(key: _clientIndexKey);
    if (rawHostsJson == null) {
      rawHostsJson = jsonEncode([]);
      await storage.write(key: _clientIndexKey, value: rawHostsJson);
    }
    List<String> jsonHosts = jsonDecode(rawHostsJson).cast<String>();
    return jsonHosts;
  }

  Future<void> setupClient(KuebikoConfig config, String localName) async {
    if (_clients.keys.contains(localName)) {
      return;
    }
    await storage.write(key: _getClientKey(localName), value: jsonEncode({
      'apiKey': config.apiKey,
      'deviceName': config.deviceName,
      'name': localName
    }));
    await _saveLocalNames();
  }

  Future<void> _saveLocalNames() async {
    await storage.write(key: _clientIndexKey, value: jsonEncode(_clients.keys.toList()));
  }

  Future<bool> addLocalClient(String name) async {
    return await addClient(LocalClient(name), name);
  }

  Future<bool> addKuebikoClient(Uri hostAddress, String deviceName, String username, String password, String localName) async {
    KuebikoClient newClient = await KuebikoClient.login(
        KuebikoConfig(
            appName: 'Official Kuebiko App',
            appVersion: Version(1, 0, 0),
            baseUrl: hostAddress,
            deviceName: deviceName
        ),
        username,
        password
    );

    await addClient(newClient, localName);
    return true;
  }

  String _getClientKey(String localName) => 'clients.$localName'; 

  Future<bool> addClient(Client client, String localName) async {
    String className = client.runtimeType.toString();
    if (_clients.keys.contains(localName)) {
      throw Exception('clientname already used');
    }

    Directory baseDirectory = await getApplicationDocumentsDirectory();
    Directory('${baseDirectory.path}/$localName').createSync();

    Map<String, dynamic> data = _getClientSpecificData(client);
    data['type'] = className;

    _clients.addAll({localName: client});
    await _saveLocalNames();

    await storage.write(key: _getClientKey(localName), value: jsonEncode(data));
    return true;
  }
  
  Map<String, dynamic> _getClientSpecificData(Client client) {
    Map<String, dynamic> data = {};
    
    switch (client) {
      case KuebikoClient kuebikoClient:
        KuebikoConfig config = kuebikoClient.getConfig();
        data = {
          'apiKey': config.apiKey,
          'deviceName': config.deviceName,
          'host': config.baseUrl.toString()
        };
    }
    
    return data;
  }

   Future<bool> removeClient(String localName) async {
    _clients.remove(localName);
    await _saveLocalNames();
    await storage.delete(key: _getClientKey(localName));
    return true;
  }

  String? getCurrentLocalName() {
    for (String localName in _clients.keys) {
      if (_clients[localName] == selectedClient) {
        return localName;
      }
    }
    return null;
  }

  Future<void> _initClients() async {
    List localNames = await _loadLocalNames();
    Map<String, Client> configMap = {};
    for (String localName in localNames) {
      String? configStringRaw = await storage.read(key: _getClientKey(localName));
      if (configStringRaw == null) {
        continue;
      }
      Map configRaw = jsonDecode(configStringRaw);
      try {
        switch(configRaw['type']) {
          case 'KuebikoClient':
            configMap[localName] = KuebikoClient(
                KuebikoConfig(
                    appName: 'Official Kuebiko App',
                    appVersion: Version(1, 0, 0),
                    baseUrl: Uri.parse(configRaw['host']),
                    deviceName: configRaw['deviceName'],
                    apiKey: configRaw['apiKey']
                )
            );
          case 'LocalClient':
            configMap[localName] = LocalClient(localName);
        }
      } catch(exception){
        // do nothing
      }
    }
    // ensure that the map is empty
    _clients.clear();
    _clients.addAll(configMap);
    clientsLoaded.broadcast();
  }

  Map<String, Client> get clients => _clients;
}