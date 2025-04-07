import 'dart:convert';

import 'package:event/event.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/cache/storage.dart';
import 'package:version/version.dart';

Event clientsLoaded = Event();
class ClientService {
  static final ClientService service = ClientService();
  final List<String> _hosts = [];
  final Map<String, KuebikoClient> _clients = {};
  KuebikoClient? selectedClient;

  ClientService() {
    _initClient();
  }

  Future<List<String>> _loadHosts() async {
    String? rawHostsJson = await storage.read(key: 'hosts');
    if (rawHostsJson == null) {
      rawHostsJson = jsonEncode([]);
      await storage.write(key: 'hosts', value: rawHostsJson);
    }
    List<String> jsonHosts = jsonDecode(rawHostsJson).cast<String>();
    return jsonHosts;
  }

  Future<void> setupClient(KuebikoConfig config, String localName) async {
    if(_hosts.contains(config.baseUrl.toString())){
      return;
    }
    await storage.write(key: config.baseUrl.toString(), value: jsonEncode({
      'apiKey': config.apiKey,
      'deviceName': config.deviceName,
      'name': localName
    }));
    _addHost(config.baseUrl.toString());
  }

  Future<void> _addHost(String host) async {
    _hosts.add(host);
    await storage.write(key: 'hosts', value: jsonEncode(_hosts));
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
    _clients.addAll({hostAddress.toString(): newClient});
    await storage.write(key: 'hosts', value: jsonEncode(_hosts));
    await storage.write(key: hostAddress.toString(), value: jsonEncode({
      'apiKey': newClient.getConfig().apiKey,
      'deviceName': deviceName,
      'name': localName
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

  Future<void> _initClient() async {
    List hosts = await _loadHosts();
    Map<String, KuebikoClient> configMap = {};
    for (String host in hosts) {
      String? configStringRaw = await storage.read(key: host);
      if (configStringRaw == null) {
        continue;
      }
      Map configRaw = jsonDecode(configStringRaw);
      try {
        configMap[configRaw['name']] = KuebikoClient(
            KuebikoConfig(
                appName: 'Official Kuebiko App',
                appVersion: Version(1, 0, 0),
                baseUrl: Uri.parse(host),
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

  get clients => _clients;
}