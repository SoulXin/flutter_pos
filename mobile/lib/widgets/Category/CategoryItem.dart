import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Category.dart';
import '../../screens/Category/Detail.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Category>(context, listen: true);

    return ListView.builder(
      itemCount: data.items.length,
      itemBuilder: (context, index) {
        var listTileItem = data.items[index];
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
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(id: listTileItem.id),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
