import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/services/setup.dart';

class SetupPage extends StatefulWidget {
  static const route = '/setup';
  const SetupPage({super.key});

  @override
  State<StatefulWidget> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  String _smtpEncryption = 'TLS';
  final TextEditingController _host = TextEditingController();
  final TextEditingController _scanInterval = TextEditingController();
  final TextEditingController _anilistToken = TextEditingController();
  final TextEditingController _apiKey = TextEditingController();

  final TextEditingController _databaseHost = TextEditingController();
  final TextEditingController _databasePort = TextEditingController();
  final TextEditingController _databaseUser = TextEditingController();
  final TextEditingController _databasePassword = TextEditingController();
  final TextEditingController _databaseName = TextEditingController();

  final TextEditingController _smtpHost = TextEditingController();
  final TextEditingController _smtpPort = TextEditingController();
  final TextEditingController _smtpUser = TextEditingController();
  final TextEditingController _smtpPassword = TextEditingController();

  final TextEditingController _adminUsername = TextEditingController();
  final TextEditingController _adminEmail = TextEditingController();
  final TextEditingController _adminPassword = TextEditingController();
  final TextEditingController _adminPasswordConfirm = TextEditingController();
  final TextEditingController _adminAnilistName = TextEditingController();
  final TextEditingController _adminAnilistToken = TextEditingController();

  final TextEditingController _deviceName = TextEditingController();
  final TextEditingController _localName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _validateInt(String? value){
    if(int.tryParse(value!) == null){
      return 'Nur numerische Werte sind erlaubt';
    }
    return null;
  }
  String? _validateEmpty(String? value){
    if(value!.trim().isEmpty){
      return 'Darf nicht leer sein';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets paddingOutline = EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 40
    );
    const EdgeInsets paddingTextFieldLeft = EdgeInsets.only(
      right: 10,
    );
    const EdgeInsets paddingTextFieldRight = EdgeInsets.only(
      left: 10,
    );
    const EdgeInsets paddingHeader = EdgeInsets.only(
        top: 40,
        bottom: 10,
        right: 40,
        left: 40
    );
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor
          ),
          child: ListView(
              children: [
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                controller: _host,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (String? value){
                                  Uri hostUri = Uri.parse(value!);
                                  if (hostUri.host.isEmpty || !hostUri.hasScheme || hostUri.scheme != 'https' && hostUri.scheme != 'http'){
                                    return 'Url ist ungültig';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Host Adresse'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldRight,
                              child: TextFormField(
                                controller: _scanInterval,
                                validator: _validateInt,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'Scan Interval in Sekunden'
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                controller: _anilistToken,
                                validator: _validateEmpty,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'Anilist Token'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldRight,
                              child: TextFormField(
                                controller: _localName,
                                validator: _validateEmpty,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'ServerName'
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                controller: _apiKey,
                                validator: _validateEmpty,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'API Key'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Container()
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: paddingHeader,
                  child: Text(
                    'Datenbank',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                controller: _databaseHost,
                                validator: _validateEmpty,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'Datenbank Host'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldRight,
                              child: TextFormField(
                                validator: _validateInt,
                                controller: _databasePort,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'Datenbank Port'
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                validator: _validateEmpty,
                                controller: _databaseUser,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'Datenbank Benutzername'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldRight,
                              child: TextFormField(
                                controller: _databasePassword,
                                validator: _validateEmpty,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'Datenbank Passwort'
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: TextFormField(
                                controller: _databaseName,
                                validator: _validateEmpty,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'Datenbank Name'
                                ),
                              )
                          )
                      ),
                      Expanded(child: Container(),)
                    ],
                  ),
                ),
                const Padding(
                  padding: paddingHeader,
                  child: Text(
                    'SMTP',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                validator: _validateEmpty,
                                controller: _smtpHost,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'SMTP Host'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldRight,
                              child: TextFormField(
                                controller: _smtpPort,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: _validateInt,
                                decoration: const InputDecoration(
                                    hintText: 'SMTP Port'
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                validator: _validateEmpty,
                                controller: _smtpUser,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'SMTP Benutzername'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldRight,
                              child: TextFormField(
                                validator: _validateEmpty,
                                controller: _smtpPassword,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    hintText: 'SMTP Passwort'
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: DropdownButton(
                                value: _smtpEncryption,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'TLS',
                                    child: Text(
                                      'TLS',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'SSL',
                                    child: Text(
                                      'SSL',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'STARTTLS',
                                    child: Text(
                                      'STARTTLS',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'NONE',
                                    child: Text(
                                      'None',
                                    ),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    _smtpEncryption = value!;
                                  });
                                },
                              )
                          )
                      ),
                      Expanded(child: Container(),)
                    ],
                  ),
                ),
                const Padding(
                  padding: paddingHeader,
                  child: Text(
                    'Admin Zugangsdaten',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _adminUsername,
                                decoration: const InputDecoration(
                                    hintText: 'Benutzername'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldRight,
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _adminEmail,
                                validator: (String? value){
                                  RegExp regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if(!regex.hasMatch(value!)){
                                    return 'E-Mail Adresse ist ungültig';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'E-Mail Adresse'
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                obscureText: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _adminPassword,
                                validator: (String? value){
                                  String? error = _validateEmpty(value);
                                  if(error != null) {
                                    return error;
                                  }
                                  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*[\d\X])(?=.*[!$#%.:,;\-_+*~"§&/()=?ß\\}\]\[{ẞ♥@€´`^°]).{8,}$');
                                  if(!regex.hasMatch(value!)){
                                    return 'Das Passwort muss mindestens 8 Zeichen lang sein, Groß und Kleinbuchstaben, eine Zahl und ein Sonderzeichen enthalten';
                                  }
                                  if(value != _adminPasswordConfirm.value.text){
                                    return 'Die Passwörter stimmen nicht überein';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Passwort'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldRight,
                              child: TextFormField(
                                obscureText: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _adminPasswordConfirm,
                                validator: (String? value){
                                  String? error = _validateEmpty(value);
                                  if(error != null) {
                                    return error;
                                  }
                                  if(value! != _adminPassword.value.text){
                                    return 'Die Passwörter stimmen nicht überein';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Passwort bestätigen'
                                ),
                              )
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: paddingOutline,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: paddingTextFieldLeft,
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _deviceName,
                                validator: _validateEmpty,
                                decoration: const InputDecoration(
                                    hintText: 'Gerätename'
                                ),
                              )
                          )
                      ),
                      Expanded(
                          child: Container()
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: TextButton(
                      style: Theme.of(context).textButtonTheme.style,
                      onPressed: () async {
                        if(!_formKey.currentState!.validate()){
                          return;
                        }
                        await SetupService.setupServer(
                          _deviceName.value.text,
                          _smtpHost.value.text,
                          int.parse(_smtpPort.value.text),
                          _smtpUser.value.text,
                          _smtpPassword.value.text,
                          _smtpEncryption,
                          _databaseHost.value.text,
                          int.parse(_databasePort.value.text),
                          _databaseUser.value.text,
                          _databasePassword.value.text,
                          _databaseName.value.text,
                          int.parse(_scanInterval.value.text),
                          _host.value.text,
                          _anilistToken.value.text,
                          _adminUsername.value.text,
                          _adminEmail.value.text,
                          _adminPassword.value.text,
                          _adminAnilistName.value.text,
                          _adminAnilistToken.value.text,
                          _localName.value.text,
                          _apiKey.value.text
                        );
                      },
                      child: const Text('Installation starten')
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}