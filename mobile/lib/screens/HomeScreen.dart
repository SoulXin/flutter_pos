import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile/providers/Category.dart';
import 'package:mobile/widgets/DropdownCategory.dart';
import '../providers/Auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<Category>(context, listen: false).getCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [const DropdownCategory()],
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(auth.user.avatar),
                        radius: 35,
                      ),
                      SizedBox(height: 20),
                      Text(auth.user.username),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
