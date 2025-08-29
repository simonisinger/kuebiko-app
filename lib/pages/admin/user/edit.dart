import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import 'package:kuebiko_web_client/widget/action_button.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';
import 'package:kuebiko_web_client/widget/user/form.dart';

class AdminUserEditPage extends StatefulWidget {
  static const String route = '/admin/user/edit';
  final User user;
  const AdminUserEditPage({super.key, required this.user});

  @override
  State<AdminUserEditPage> createState() => _AdminUserEditPageState();
}

class _AdminUserEditPageState extends State<AdminUserEditPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        UserForm(
            user: widget.user,
            onActionButtonTap: () {
              widget.user.adminUpdate();
            },
        )
    );
  }
}
