import 'package:flutter/material.dart';
import 'package:mobile/models/ProductModel.dart';
import 'package:mobile/providers/Products.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class FormProduct extends StatefulWidget {
  final int? id;
  final bool formAdd;

  const FormProduct({
    Key? key,
    this.id,
    required this.formAdd,
  }) : super(key: key);

  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final GlobalKey<FormState> formKey = GlobalKey();
  Map<String, dynamic> formData = {
    'categories_id': 0,
    'name': '',
    'price': 0,
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
        await Provider.of<Products>(context, listen: false).add(
          name: formData['name'] as String,
          price: int.parse(formData['price']),
          categoriesId: formData['categories_id'],
        );

        Navigator.of(context).pop();
      } else {
        await Provider.of<Products>(context, listen: false).update(
          id: widget.id,
          name: formData['name'] as String,
          price: int.parse(formData['price']),
          categoriesId: formData['categories_id'],
        );
      }
    } catch (error) {
      throw error;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Products>(context, listen: true);

    final nameController = TextEditingController(
      text: isLoading
          ? formData['name']
          : data.temp.values.isNotEmpty
              ? data.temp.values.first.name
              : '',
    );

    final priceController = TextEditingController(
      text: isLoading
          ? formData['price']
          : data.temp.values.isNotEmpty
              ? data.temp.values.first.price.toString()
              : '',
    );

    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama'),
                controller: widget.formAdd ? null : nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  } else if (value.length < 5) {
                    return 'Nama terlalu pendek';
                  }
                  return null;
                },
                onSaved: (value) {
                  formData['name'] = value;
                },
              ),
              TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga'),
                controller: widget.formAdd ? null : priceController,
                validator: (value) {
                  if (value!.isEmpty || int.parse(value) < 1) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  formData['price'] = value;
                },
              ),
              DropdownButton(
                dropdownColor: Theme.of(context).backgroundColor,
                isExpanded: true,
                hint: Text(
                  'Kategori',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                value: data.selectedCategory.isNotEmpty
                    ? data.selectedCategory
                    : null,
                items: data.itemsCategory.map((item) {
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
                onChanged: (value) {
                  var dataValue = data.itemsCategory
                      .firstWhere((element) => element.name == value);
                  data.changeSelected(name: dataValue.name);
                  formData['categories_id'] = dataValue.id;
                },
              ),
            ],
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
                  child: widget.formAdd ? Text('Tambah') : Text('Update'),
                  onPressed: submit,
                  style: style,
                )
              ],
            ),
          ),
      ],
    );
  }
}
