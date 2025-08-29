import 'package:flutter/material.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/pages/admin/user/edit.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/widget/base_scaffold.dart';

class AdminUserListPage extends StatefulWidget {
  static const String route = '/admin/user/list';
  const AdminUserListPage({super.key});

  @override
  State<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        FutureBuilder(
            future: ClientService.service.selectedClient!.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                          User user = snapshot.data![index];
                          return ListTile(
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator
                                      .of(context)
                                      .pushNamed(
                                        AdminUserEditPage.route,
                                        arguments: user
                                      );
                                },
                                icon: Icon(Icons.edit)
                            ),
                          );
                      });
                } else {
                  return Text(snapshot.error.toString());
                }
              } else {
                return CircularProgressIndicator();
              }
            }
        )
    );
  }
}
