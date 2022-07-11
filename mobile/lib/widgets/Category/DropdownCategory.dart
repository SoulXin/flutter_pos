import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Category.dart';
import '../../providers/Products.dart';

class DropdownCategory extends StatefulWidget {
  const DropdownCategory({Key? key}) : super(key: key);

  @override
  State<DropdownCategory> createState() => _DropdownCategoryState();
}

class _DropdownCategoryState extends State<DropdownCategory> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Category>(context, listen: true).items;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      child: DropdownButton(
        dropdownColor: Theme.of(context).backgroundColor,
        isExpanded: true,
        hint: Text(
          'Kategori',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        value: selected,
        items: data.map((item) {
          return DropdownMenuItem(
            child: Text(
              item.name,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
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
