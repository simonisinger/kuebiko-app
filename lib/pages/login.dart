import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/services/client.dart';

class LoginPage extends StatelessWidget {
  static const route = '/login';
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _hostAddress = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _serverName = TextEditingController();
  final TextEditingController _deviceName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width;
    if(MediaQuery.of(context).size.width > 768){
      width = 768;
    } else {
      width = MediaQuery.of(context).size.width;
    }

    EdgeInsets inputMargin = const EdgeInsets.symmetric(vertical: 10);

    InputBorder? inputBorder = UnderlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).shadowColor
        )
    );

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: width,
          child: Form(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Text(
                      'Neuen Server hinzufügen',
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).primaryColor
                      ),
                    )
                ),
                Padding(
                  padding: inputMargin,
                  child: TextFormField(
                      controller: _hostAddress,
                      decoration: InputDecoration(
                          hintText: 'Serveradresse',
                          labelText: 'Serveradresse',
                          border: inputBorder
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        Uri hostUri = Uri.parse(value!);
                        if (hostUri.host.isEmpty || !hostUri.hasScheme || hostUri.scheme != 'https' && hostUri.scheme != 'http'){
                          return 'Url ist ungültig';
                        }
                        return null;
                      }
                  ),
                ),
                Padding(
                  padding: inputMargin,
                  child: TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                        hintText: 'E-Mail Adresse',
                        labelText: 'E-Mail Adresse',
                        border: inputBorder
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Padding(
                  padding: inputMargin,
                  child: TextFormField(
                    obscureText: true,
                    controller: _password,
                    decoration: InputDecoration(
                        hintText: 'Passwort',
                        labelText: 'Passwort',
                        border: inputBorder
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Padding(
                  padding: inputMargin,
                  child: TextFormField(
                    controller: _serverName,
                    decoration: InputDecoration(
                        hintText: 'Servername',
                        labelText: 'Servername',
                        border: inputBorder
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Padding(
                  padding: inputMargin,
                  child: TextFormField(
                    controller: _deviceName,
                    decoration: InputDecoration(
                        hintText: 'Gerätename',
                        labelText: 'Gerätename',
                        border: inputBorder
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Container(
                  padding: inputMargin,
                  width: width,
                  child: TextButton(
                    onPressed: () async {
                      await ClientService.service.addClient(
                          Uri.parse(_hostAddress.value.text),
                          _deviceName.value.text,
                          _username.value.text,
                          _password.value.text,
                          _serverName.value.text
                      );
                      Navigator.of(context).popAndPushNamed('/client-selection');
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}