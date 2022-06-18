import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile/models/ProductModel.dart';
import 'package:mobile/providers/Carts.dart';
import 'package:mobile/providers/Products.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Products>(context, listen: true);
    final cart = Provider.of<Carts>(context, listen: false);

    return data.loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: data.items.length,
            itemBuilder: (context, index) {
              var listTileItem = data.items[index] as ProductModel;
              return Card(
                child: ListTile(
                  title: Text(listTileItem.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          cart.removeItem(product: listTileItem);
                        },
                        color: Colors.black,
                      ),
                      Text('0'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          cart.addItem(product: listTileItem);
                        },
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
