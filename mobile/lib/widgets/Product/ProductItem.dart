import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/ProductModel.dart';
import 'package:mobile/providers/Products.dart';
import 'package:provider/provider.dart';
import 'ProductButton.dart';

class ProductItem extends StatelessWidget {
  final bool productScreen;

  const ProductItem({Key? key, required this.productScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Products>(context, listen: true);
    final moneyFormat = NumberFormat("#,##0", "id_ID");

    return data.loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: data.items.length,
            itemBuilder: (context, index) {
              var listTileItem = data.items[index] as ProductModel;
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Theme.of(context).backgroundColor,
                child: ListTile(
                  title: Text(
                    listTileItem.name,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  trailing: ProductButton(
                    id: listTileItem.id,
                    name: listTileItem.name,
                    price: listTileItem.price,
                    productScreen: productScreen,
                  ),
                  subtitle:
                      Text('Rp. ${moneyFormat.format(listTileItem.price)}'),
                ),
              );
            },
          );
  }
}
