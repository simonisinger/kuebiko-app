import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

import '../../widget/action_button.dart';
import '../../../../generated/i18n/app_localizations.dart';

class UserForm extends StatefulWidget {
  final User? user;
  final String? actionButtonText;
  final bool currentPasswordField;
  final Function() onActionButtonTap;

  UserForm({
    super.key,
    required this.user,
    this.actionButtonText,
    required this.onActionButtonTap,
    this.currentPasswordField = false
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordConfirmationController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();

  final List<String> roles = [];

  _UserFormState() {
    if (widget.user != null) {
      emailController.text = widget.user!.email;
      nameController.text = widget.user!.name;
      roles.addAll(widget.user!.roles);
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
            widget.currentPasswordField ? TextFormField(
              controller: newPasswordController,
              decoration: InputDecoration(
                  labelText: localizations.currentPassword,
                  hintText: localizations.currentPassword
              ),
            ) : Container(),
            TextFormField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: localizations.newPassword,
                hintText: localizations.newPassword
              ),
              validator: (_) {
                if (newPasswordController.text != newPasswordConfirmationController.text) {
                  return localizations.passwordNotEqual;
                }
                return null;
              },
            ),
            TextFormField(
              controller: newPasswordConfirmationController,
              decoration: InputDecoration(
                labelText: localizations.newPasswordConfirmation,
                hintText: localizations.newPasswordConfirmation
              ),
            ),
            DropdownMenu(
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 'Admin', label: localizations.admin),
              DropdownMenuEntry(value: 'User', label: localizations.user)
              ],
              hintText: localizations.role,
              label: Text(localizations.role),
            ),
            ActionButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onActionButtonTap();
                  }
                },
                buttonText: widget.actionButtonText ?? localizations.save
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
