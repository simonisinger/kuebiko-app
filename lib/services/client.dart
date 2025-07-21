import 'dart:convert';

import 'package:event/event.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/cache/storage.dart';
import 'package:version/version.dart';

Event clientsLoaded = Event();
class ClientService {
  static final ClientService service = ClientService();
  final List<String> _hostNames = [];
  final Map<String, KuebikoClient> _clients = {};
  KuebikoClient? selectedClient;
  Library? selectedLibrary;

  ClientService() {
    _initClient();
  }

  Future<List<String>> _loadHosts() async {
    String? rawHostsJson = await storage.read(key: 'hostNames');
    if (rawHostsJson == null) {
      rawHostsJson = jsonEncode([]);
      await storage.write(key: 'hostNames', value: rawHostsJson);
    }
    List<String> jsonHosts = jsonDecode(rawHostsJson).cast<String>();
    return jsonHosts;
  }

  Future<void> setupClient(KuebikoConfig config, String localName) async {
    if(_hostNames.contains(config.baseUrl.toString())){
      return;
    }
    await storage.write(key: config.baseUrl.toString(), value: jsonEncode({
      'apiKey': config.apiKey,
      'deviceName': config.deviceName,
      'name': localName
    }));
    _addHostName(config.baseUrl.toString());
  }

  Future<void> _addHostName(String hostName) async {
    _hostNames.add(hostName);
    await storage.write(key: 'hostNames', value: jsonEncode(_hostNames));
  }

  Future<bool> addClient(Uri hostAddress, String deviceName, String username, String password, String localName) async {
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
    _clients.addAll({localName: newClient});
    _hostNames.add(localName);
    await storage.write(key: 'hostNames', value: jsonEncode(_hostNames));
    await storage.write(key: localName, value: jsonEncode({
      'apiKey': newClient.getConfig().apiKey,
      'deviceName': deviceName,
      'host': hostAddress.toString()
    }));
    return true;
  }

   Future<bool> removeClient(String localName) async {
    String hostAddress = _clients[localName]!.getConfig().baseUrl.toString();
    _clients.remove(localName);
    await storage.write(key: 'hosts', value: jsonEncode(_clients.keys));
    await storage.delete(key: hostAddress.toString());
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

  Future<void> _initClient() async {
    List hostNames = await _loadHosts();
    Map<String, KuebikoClient> configMap = {};
    for (String hostName in hostNames) {
      String? configStringRaw = await storage.read(key: hostName);
      if (configStringRaw == null) {
        continue;
      }
      Map configRaw = jsonDecode(configStringRaw);
      try {
        configMap[hostName] = KuebikoClient(
            KuebikoConfig(
                appName: 'Official Kuebiko App',
                appVersion: Version(1, 0, 0),
                baseUrl: Uri.parse(configRaw['host']),
                deviceName: configRaw['deviceName'],
                apiKey: configRaw['apiKey']
            )
        );
      } catch(exception){
        // do nothing
      }
    }
    // ensure that the map is empty
    _clients.clear();
    _clients.addAll(configMap);
    clientsLoaded.broadcast();
  }

  Map<String, KuebikoClient> get clients => _clients;
}