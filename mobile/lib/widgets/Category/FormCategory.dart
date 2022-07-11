import 'package:flutter/material.dart';
import 'package:mobile/widgets/ShowDialog.dart';
import 'package:provider/provider.dart';
import '../../models/MessageException.dart';
import '../../providers/Category.dart';

class FormCategory extends StatefulWidget {
  final int? id;
  final bool formAdd;

  const FormCategory({
    Key? key,
    this.id,
    required this.formAdd,
  }) : super(key: key);

  @override
  State<FormCategory> createState() => _FormCategoryState();
}

class _FormCategoryState extends State<FormCategory> {
  final GlobalKey<FormState> formKey = GlobalKey();
  Map<String, String> formData = {
    'name': '',
  };
  var isLoading = false;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.formAdd) {
        await Provider.of<Category>(context, listen: false)
            .add(
              name: formData['name'] as String,
            )
            .then((value) => showSuccessDialog(context, value));
      } else {
        await Provider.of<Category>(context, listen: false)
            .update(
              id: widget.id,
              name: formData['name'] as String,
            )
            .then((value) => showSuccessDialog(context, value));
      }
    } on MessageException catch (error) {
      showErrorDialog(context, error.message);
    } catch (error) {
      showErrorDialog(context, error.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(
        text: isLoading
            ? formData['name']
            : Provider.of<Category>(context, listen: true).name);

    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Nama'),
            controller: widget.formAdd ? null : nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Kategori tidak boleh kosong';
              } else if (value.length < 5) {
                return 'Kategori terlalu pendek';
              }
              return null;
            },
            onSaved: (value) {
              formData['name'] = value as String;
            },
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(15),
            child: CircularProgressIndicator(),
          )
        else
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: submit,
                  style: style,
                  child: widget.formAdd
                      ? const Text('Tambah')
                      : const Text('Update'),
                )
              ],
            ),
          ),
      ],
    );
  }
}
