import 'package:flutter/material.dart';
import 'package:mobile/models/MessageException.dart';
import 'package:mobile/widgets/ShowDialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/Carts.dart';

class CartItem extends StatelessWidget {
  const CartItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneyFormat = NumberFormat("#,##0", "id_ID");
    final data = Provider.of<Carts>(context);

    return ListView.builder(
      itemCount: data.items.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(data.items.toList()[index].id),
        background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          try {
            await Provider.of<Carts>(context, listen: false)
                .removeItem(data.items.toList()[index].id);
          } on MessageException catch (error) {
            showErrorDialog(context, error.message);
          } catch (error) {
            showErrorDialog(context, error.toString());
          }
        },
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you sure?'),
              content:
                  const Text('Do you want to remove the item from the cart?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: const Text('Yes'))
              ],
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          color: Theme.of(context).backgroundColor,
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(
                data.items.toList()[index].name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'Rp. ${moneyFormat.format(data.items.toList()[index].price)}'),
                  Text(
                    'Total: Rp. ${moneyFormat.format(data.items.toList()[index].price * data.items.toList()[index].quantity)}',
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      try {
                        await Provider.of<Carts>(context, listen: false)
                            .decrementItem(data.items.toList()[index].id);
                      } on MessageException catch (error) {
                        showErrorDialog(context, error.message);
                      } catch (error) {
                        showErrorDialog(context, error.toString());
                      }
                    },
                    icon: Icon(Icons.remove),
                    color: Colors.black,
                  ),
                  Text('${data.items.toList()[index].quantity}'),
                  IconButton(
                    onPressed: () async {
                      try {
                        await Provider.of<Carts>(context, listen: false)
                            .incrementItem(data.items.toList()[index].id);
                      } on MessageException catch (error) {
                        showErrorDialog(context, error.message);
                      } catch (error) {
                        showErrorDialog(context, error.toString());
                      }
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
