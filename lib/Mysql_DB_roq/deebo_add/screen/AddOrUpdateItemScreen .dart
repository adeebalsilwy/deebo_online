import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/items.dart';

class ItemAddOrUpdateScreen extends StatefulWidget {
  final Item? item;

  ItemAddOrUpdateScreen({Key? key, this.item}) : super(key: key);

  @override
  _ItemAddOrUpdateScreenState createState() => _ItemAddOrUpdateScreenState();
}

class _ItemAddOrUpdateScreenState extends State<ItemAddOrUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemCodeController;
  late TextEditingController _itemNameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late Future<File?>? _imageFuture;
  late int _categoryId;

  @override
  void initState() {
    super.initState();
    _itemCodeController =
        TextEditingController(text: widget.item?.itemCode ?? '');
    _itemNameController =
        TextEditingController(text: widget.item?.itemName ?? '');
    _priceController =
        TextEditingController(text: widget.item?.price.toString() ?? '');
    _stockController =
        TextEditingController(text: widget.item?.stock.toString() ?? '');
    _categoryId = widget.item?.categoryId ?? 0;
    _imageFuture = widget.item?.imagePro != null
        ? Future.value(File(widget.item!.imagePro!))
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Update Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _itemCodeController,
                  decoration: InputDecoration(
                    labelText: 'Item Code',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a stock quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid stock quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                FutureBuilder<File?>(
                  future: _imageFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return GestureDetector(
                      onTap: () async {
                        final pickedFile = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            _imageFuture = Future.value(File(pickedFile.path));
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: snapshot.data != null
                            ? Image.file(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo),
                                  Text('Add Photo'),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _categoryId,
                  onChanged: (value) {
                    setState(() {
                      _categoryId = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Category 1'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('Category 2'),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('Category 3'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // perform save or update operation
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
