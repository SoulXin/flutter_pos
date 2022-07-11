import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/MessageException.dart';
import '../../providers/Category.dart';
import '../../widgets/ShowDialog.dart';
import '../../widgets/Category/CategoryItem.dart';
import './Add.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  static const routeName = '/category';

  void fetchDataCategory(BuildContext context) async {
    try {
      await Provider.of<Category>(context, listen: false).fetchData();
    } on MessageException catch (error) {
      showErrorDialog(context, error.message);
    } catch (error) {
      showErrorDialog(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchDataCategory(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Kategori'),
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Add(),
                ),
              );
            },
          ),
        ],
      ),
      body: const CategoryItem(),
    );
  }
}
