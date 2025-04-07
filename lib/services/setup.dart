import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:version/version.dart';
import 'client.dart';

class SetupService {
  static setupServer(
      String deviceName,
      String smtpHost,
      int smtpPort,
      String smtpUser,
      String smtpPassword,
      String smtpEncryption,
      String databaseHost,
      int databasePort,
      String databaseUser,
      String databasePassword,
      String databaseName,
      int scanInterval,
      String url,
      String anilistToken,
      String adminUsername,
      String adminEmail,
      String adminPassword,
      String adminAnilistName,
      String adminAnilistToken,
      String localName,
      String apiKey
      ) async {
    KuebikoConfig config = KuebikoConfig(
        appVersion: Version(1, 0, 0),
        deviceName: deviceName,
        appName: 'KuebikoApp',
        baseUrl: Uri.parse(url),
        apiKey: apiKey
    );
    await setup(
        config: config,
        smtpConfig: SmtpConfig(
            host: Uri.parse(smtpHost),
            port: smtpPort,
            username: smtpUser,
            password: smtpPassword,
            encryption: smtpEncryption
        ),
        mysqlConfig: MysqlConfig(
            host: databaseHost,
            port: databasePort,
            username: databaseUser,
            password: databasePassword,
            database: databaseName
        ),
        scanInterval: scanInterval,
        url: Uri.parse(url),
        anilistToken: anilistToken,
        adminUsername: adminUsername,
        adminEmail: adminEmail,
        adminPassword: adminPassword,
        adminAnilistName: adminAnilistName,
        adminAnilistToken: adminAnilistToken
    );
    KuebikoClient client = await KuebikoClient.login(
        config,
        adminUsername,
        adminPassword
    );
    config = client.getConfig();
    ClientService.service.setupClient(config, localName);
  }
}