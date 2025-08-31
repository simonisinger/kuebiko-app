import 'package:flutter/material.dart';
import '../../../widget/base_scaffold.dart';
import '../../../widget/user/form.dart';

class AdminUserAddPage extends StatelessWidget {
  static const String route = '/admin/user/add';
  const AdminUserAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(UserForm(user: null,));
  }
}
