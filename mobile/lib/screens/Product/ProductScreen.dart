import 'package:flutter/material.dart';
import 'package:mobile/providers/Products.dart';
import 'package:mobile/widgets/Product/ProductItem.dart';
import 'package:provider/provider.dart';
import './Add.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  static const routeName = '/product';

  @override
  Widget build(BuildContext context) {
    Provider.of<Products>(context, listen: false).fetchData();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Produk'),
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Add(),
                ),
              );
            },
          ),
        ],
      ),
      body: const ProductItem(
        productScreen: true,
      ),
    );
  }
}
