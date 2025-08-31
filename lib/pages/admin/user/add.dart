import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/generated/i18n/app_localizations.dart';
import '../../../widget/base_scaffold.dart';
import '../../../widget/user/form.dart';

class AdminUserAddPage extends StatelessWidget {
  static const String route = '/admin/user/add';
  const AdminUserAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        UserForm(
          user: null,
          actionButtonText: AppLocalizations.of(context)!.createAccount,
        )
    );
  }
}
