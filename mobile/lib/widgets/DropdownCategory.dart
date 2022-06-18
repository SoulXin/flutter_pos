import 'package:flutter/material.dart';
import 'package:mobile/providers/Category.dart';
import 'package:mobile/providers/Products.dart';
import 'package:provider/provider.dart';

class DropdownCategory extends StatefulWidget {
  const DropdownCategory({Key? key}) : super(key: key);

  @override
  State<DropdownCategory> createState() => _DropdownCategoryState();
}

class _DropdownCategoryState extends State<DropdownCategory> {
  String? selected = null;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Category>(context, listen: true).items;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      child: DropdownButton(
        isExpanded: true,
        hint: Text('Kategory'),
        value: selected,
        items: data.map((item) {
          return new DropdownMenuItem(
            child: new Text(item.name),
            value: item.name,
          );
        }).toList(),
        onChanged: (value) async {
          var dataValue =
              data.firstWhere((element) => element.name == value.toString());

          setState(() {
            selected = value.toString();
          });

          await Provider.of<Products>(context, listen: false)
              .setLoading(value: true);
          await Provider.of<Products>(context, listen: false)
              .getProducts(id: dataValue.id);
        },
      ),
    );
  }
}
