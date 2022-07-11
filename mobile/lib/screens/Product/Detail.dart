import 'package:flutter/material.dart';
import 'package:mobile/providers/Products.dart';
import 'package:mobile/widgets/Product/FormProduct.dart';
import 'package:provider/provider.dart';

class Detail extends StatelessWidget {
  final int id;

  const Detail({Key? key, required this.id}) : super(key: key);

  void delete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete the category?'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<Products>(context, listen: false)
                  .delete(id: id)
                  .then((value) => Navigator.of(context).pop());
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Products>(context, listen: false).detail(id: id);

    print("product detail");

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Theme.of(context).accentColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<Products>(context, listen: false).clearDetail();
            Navigator.of(context).pop(false);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              delete(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FormProduct(
          id: id,
          formAdd: false,
        ),
      ),
    );
  }
}
