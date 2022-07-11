import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/MessageException.dart';
import '../providers/Carts.dart';
import '../providers/Category.dart';
import '../providers/Auth.dart';
import '../screens/CartScreen.dart';
import '../screens/MasterScreen.dart';
import '../widgets/Cart/Badge.dart';
import '../widgets/Category/DropdownCategory.dart';
import '../widgets/Product/ProductItem.dart';
import '../widgets/ShowDialog.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  const HomeScreen({Key? key, required this.token}) : super(key: key);

  void fetchDataCategory(BuildContext context) async {
    try {
      await Provider.of<Category>(context, listen: false).fetchData();
    } on MessageException catch (error) {
      showErrorDialog(context, error.message);
    } catch (error) {
      showErrorDialog(context, error.toString());
    }
  }

  void fetchDataCart(BuildContext context) async {
    try {
      await Provider.of<Carts>(context, listen: false).fetchData();
    } on MessageException catch (error) {
      showErrorDialog(context, error.message);
    } catch (error) {
      showErrorDialog(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchDataCategory(context);
    fetchDataCart(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Hello'),
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          Consumer<Carts>(
            builder: (_, cartData, ch) => Badge(
              child: ch as Widget,
              value: cartData.itemCount.toString(),
              color: Colors.black,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const DropdownCategory(),
          Expanded(
            child: const ProductItem(
              productScreen: false,
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
                    color: Theme.of(context).accentColor,
                  ),
                ),
                ListTile(
                  title: const Text('Utama'),
                  leading: const Icon(Icons.home),
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
