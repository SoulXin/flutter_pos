import 'package:flutter/material.dart';
import 'package:mobile/providers/Category.dart';
import 'package:mobile/widgets/DropdownCategory.dart';
import 'package:mobile/widgets/ProductList.dart';
import '../providers/Auth.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  String token;
  HomeScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    Provider.of<Category>(context, listen: false).getCategory(authToken: token);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Column(
        children: [
          const DropdownCategory(),
          Expanded(
            child: const ProductList(),
          ),
        ],
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
