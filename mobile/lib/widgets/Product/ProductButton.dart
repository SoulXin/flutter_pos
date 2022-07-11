import 'package:flutter/material.dart';
import 'package:mobile/models/MessageException.dart';
import 'package:mobile/providers/Carts.dart';
import 'package:mobile/widgets/ShowDialog.dart';
import 'package:provider/provider.dart';
import '../../screens/Product/Detail.dart';

class ProductButton extends StatelessWidget {
  final int id;
  final String name;
  final int price;
  final bool productScreen;

  const ProductButton(
      {Key? key,
      required this.id,
      required this.name,
      required this.price,
      required this.productScreen})
      : super(key: key);

  void checkProductScreen(BuildContext context, cart) async {
    if (productScreen) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detail(id: id),
        ),
      );
    } else {
      Provider.of<Carts>(context, listen: false).setLoading(value: true);

      try {
        await cart.addItem(
          productId: id,
          name: name,
          price: price,
        );
      } on MessageException catch (error) {
        showErrorDialog(context, error.message);
      } catch (error) {
        showErrorDialog(context, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context, listen: false);
    final loadingCart = Provider.of<Carts>(context).loading;

    print("product button");

    return IconButton(
      icon: Icon(productScreen ? Icons.edit : Icons.add),
      onPressed: loadingCart
          ? null
          : () {
              checkProductScreen(context, cart);
            },
      color: Colors.black,
    );
  }
}
