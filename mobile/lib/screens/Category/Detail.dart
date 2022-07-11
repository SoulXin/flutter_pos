import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/MessageException.dart';
import '../../providers/Category.dart';
import '../../widgets/Category/FormCategory.dart';
import '../../widgets/ShowDialog.dart';

class Detail extends StatelessWidget {
  final int id;
  const Detail({Key? key, required this.id}) : super(key: key);

  void delete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete the category?'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('No')),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<Category>(context, listen: false)
                    .delete(id: id)
                    .then(
                      (value) => {
                        Navigator.of(ctx).pop(),
                        showSuccessDialog(ctx, value),
                      },
                    );
              } catch (error) {
                Navigator.of(ctx).pop();
                showErrorDialog(ctx, error.toString());
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void fetchData(BuildContext context) async {
    try {
      await Provider.of<Category>(context, listen: false)
          .fetchDataDetail(id: id);
    } on MessageException catch (error) {
      showErrorDialog(context, error.message);
    } catch (error) {
      showErrorDialog(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchData(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Detail Kategori'),
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              delete(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FormCategory(
          id: id,
          formAdd: false,
        ),
      ),
    );
  }
}
