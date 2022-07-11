import 'package:flutter/material.dart';
import '../widgets/Cart/CartItem.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: const CartItem(),
    );
  }
}
