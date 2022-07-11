import 'package:flutter/material.dart';
import 'package:mobile/providers/Products.dart';
import 'package:mobile/widgets/Product/FormProduct.dart';
import 'package:provider/provider.dart';

class Add extends StatelessWidget {
  const Add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<Products>(context, listen: false).fetchData();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const FormProduct(formAdd: true),
      ),
    );
  }
}
