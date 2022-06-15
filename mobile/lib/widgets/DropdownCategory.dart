import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/CategoryModel.dart';
import 'package:mobile/providers/Category.dart';
import 'package:provider/provider.dart';

class DropdownCategory extends StatelessWidget {
  const DropdownCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Category>(context, listen: true).items;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: DropdownButton(
        isExpanded: true,
        hint: Text('Kategory'),
        items: data.map((item) {
          return new DropdownMenuItem(
            child: new Text(item.name),
            value: item,
          );
        }).toList(),
        onChanged: (value) {
          print(value as Map<String, dynamic>);
          // Provider.of<Category>(context, listen: false).selectedCategory(value);
        },
      ),
    );
  }
}
