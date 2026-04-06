import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/vendors/j-novel-club/http_client.dart';

import '../../widget/base_scaffold.dart';

class JNovelClubLoginPage extends StatelessWidget {
  JNovelClubLoginPage({super.key});
  static const String route = '/login/jnc';
  final GlobalKey _formKey = GlobalKey();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BaseScaffold(
      Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            children: [
              TextFormField(
                autofillHints: [AutofillHints.email],
                decoration: InputDecoration(
                    hintText: localizations.email,
                    labelText: localizations.email
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null) {
                    return localizations.emailEmpty;
                  }
          
                  if (!RegExp(r"^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$").hasMatch(value)) {
                    return localizations.emailInvalid;
                  }
          
                  return null;
                },
              ),
              TextFormField(
                autofillHints: [AutofillHints.password],
                decoration: InputDecoration(
                    hintText: localizations.password,
                    labelText: localizations.password
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value == null) {
                    return localizations.passwordEmpty;
                  }
                  return null;
                },
              ),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () async {
                    FormState formState = _formKey.currentState as FormState;
                    if (formState.validate()) {
                      return;
                    }
                    try {
                      await JNovelClubHttpClient.login(_email.text, _password.text);
                    } catch(e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.invalidCredentials))
                        );  
                      }
                      return;
                    }
                    
                    if (context.mounted) {
                      Navigator.of(context).popAndPushNamed('/client-selection');
                    }
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
      )
    );
  }
}