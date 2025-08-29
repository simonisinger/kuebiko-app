import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

import '../../widget/action_button.dart';
import '../../../../generated/i18n/app_localizations.dart';

class UserForm extends StatelessWidget {
  final User? user;
  final String? actionButtonText;
  final Function() onActionButtonTap;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordConfirmationController = TextEditingController();
  final List<String> roles = [];

  UserForm({super.key, required this.user, this.actionButtonText, required this.onActionButtonTap}) {
    if (user != null) {
      emailController.text = user!.email;
      nameController.text = user!.name;
      roles.addAll(user!.roles);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 12,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: localizations.name,
                hintText: localizations.name
              ),
              validator: (String? name) {
                if (name == null || name.isEmpty) {
                  return localizations.usernameEmpty;
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: localizations.email,
                hintText: localizations.email,
              ),
              validator: (String? email) {
                if (email == null || email.isEmpty) {
                  return localizations.emailEmpty;
                }
        
                RegExp validator = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$');
                if (validator.hasMatch(email)){
                  return null;
                } else {
                  return localizations.emailInvalid;
                }
              },
            ),
            TextFormField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: localizations.newPassword,
                hintText: localizations.newPassword
              ),
            ),
            TextFormField(
              controller: newPasswordConfirmationController,
              decoration: InputDecoration(
                labelText: localizations.newPasswordConfirmation,
                hintText: localizations.newPasswordConfirmation
              ),
            ),
            ActionButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    onActionButtonTap();
                  }
                },
                buttonText: actionButtonText ?? localizations.save
            ),
            OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.cancel)
            )
          ],
        ),
      ),
    );
  }
}
