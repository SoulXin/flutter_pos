import 'package:flutter/material.dart';
import '../../widgets/Category/FormCategory.dart';

class Add extends StatelessWidget {
  const Add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Tambah Kategori'),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const FormCategory(formAdd: true),
      ),
    );
  }
}
