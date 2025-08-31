import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

import '../../pages/admin/user/list.dart';
import '../../services/client.dart';

import '../../widget/action_button.dart';
import '../../../../generated/i18n/app_localizations.dart';

class UserForm extends StatefulWidget {
  final User? user;
  final String? actionButtonText;
  final bool currentPasswordField;

  const UserForm({
    super.key,
    required this.user,
    this.actionButtonText,
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
  final TextEditingController currentPasswordController = TextEditingController();

  final List<String> roles = [];

  @override
  initState() {
    super.initState();
    if (widget.user != null) {
      emailController.text = widget.user!.email;
      nameController.text = widget.user!.name;
      roles.addAll(widget.user!.roles);
      emailController.addListener(() => widget.user!.email = emailController.text);
      nameController.addListener(() => widget.user!.name = nameController.text);
    } else {
      roles.add('User');
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
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: localizations.currentPassword,
                  hintText: localizations.currentPassword
              ),
            ) : Container(),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
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
              obscureText: true,
              decoration: InputDecoration(
                labelText: localizations.newPasswordConfirmation,
                hintText: localizations.newPasswordConfirmation
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: DropdownButton(
                items: [
                  DropdownMenuItem(
                      value: 'Admin',
                      child: Text(localizations.admin),
                  ),
                  DropdownMenuItem(
                      value: 'User',
                      child: Text(localizations.user),
                  )
                ],
                value: roles.contains('Admin') ? 'Admin' : 'User',
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      roles.clear();
                      roles.add(value);
                    }
                  });
                },
              ),
            ),
            ActionButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.user == null) {
                      ClientService.service.selectedClient!.createUser(
                          emailController.text,
                          nameController.text,
                          newPasswordController.text,
                          roles,
                          '',
                          ''
                      );
                    } else {
                      if (widget.currentPasswordField) {
                        await widget.user!.update(currentPasswordController.text);
                      } else {
                        await widget.user!.adminUpdate();
                      }
                    }
                    if (mounted) {
                      Navigator.of(this.context).pushNamedAndRemoveUntil(
                          AdminUserListPage.route,
                          (route) => route.settings.name == AdminUserListPage.route
                      );
                    }
                  }
                },
                buttonText: widget.actionButtonText ?? localizations.save
            ),
            SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localizations.cancel)
              ),
            )
          ],
        ),
      ),
    );
  }
}
