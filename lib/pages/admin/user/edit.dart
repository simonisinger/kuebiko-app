import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

import '../../../widget/base_scaffold.dart';
import '../../../widget/user/form.dart';

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
