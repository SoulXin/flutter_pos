import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile/providers/Auth.dart';
import 'package:mobile/screens/Category/CategoryScreen.dart';
import 'package:mobile/screens/HomeScreen.dart';
import 'package:mobile/screens/Product/ProductScreen.dart';
import 'package:provider/provider.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({Key? key}) : super(key: key);

  static const routeName = '/master';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Master'),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: GridView(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: Theme.of(context).hintColor,
            ),
            child: InkWell(
              splashColor: Theme.of(context).hintColor,
              onTap: () {
                Navigator.of(context).pushNamed(ProductScreen.routeName);
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fastfood,
                    size: 70,
                  ),
                  Text(
                    "Produk",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: Theme.of(context).hintColor,
            ),
            child: InkWell(
              splashColor: Theme.of(context).hintColor,
              onTap: () {
                Navigator.of(context).pushNamed(CategoryScreen.routeName);
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.list,
                    size: 70,
                  ),
                  Text(
                    "Kategori",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: Theme.of(context).hintColor,
            ),
            child: InkWell(
              splashColor: Theme.of(context).hintColor,
              onTap: () {
                print("hello");
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.table_restaurant,
                    size: 70,
                  ),
                  Text(
                    "Meja",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(auth.user.avatar),
                        radius: 35,
                      ),
                      const SizedBox(height: 20),
                      Text(auth.user.username),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Utama'),
                  leading: const Icon(Icons.account_box),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                ListTile(
                  title: const Text('Master'),
                  leading: const Icon(Icons.account_box),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(MasterScreen.routeName);
                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.logout),
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
