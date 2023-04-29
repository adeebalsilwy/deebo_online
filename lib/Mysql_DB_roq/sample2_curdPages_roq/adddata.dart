import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'package:http/http.dart' as http;

import '../deebo_add/appData.dart';
import '../deebo_add/model/categorys.dart';
import '../deebo_add/model/items.dart';
import 'listdata.dart';

class AddData extends StatefulWidget {
  @override
  _AddDataState createState() => new _AddDataState();
}

class _AddDataState extends State<AddData> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController controllerCode = new TextEditingController();
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerPrice = new TextEditingController();
  TextEditingController controllerStock = new TextEditingController();
  // TextEditingController _categoryValue = new TextEditingController();
  List<Category> _categories = [];
  late Category categoryValue;
  int _categoryId = 0; // default category id

  Future _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void addData() {
    final item = Item(
      itemCode: controllerCode.value.text,
      itemName: controllerName.value.text,
      price: int.parse(controllerPrice.value.text),
      stock: int.parse(controllerStock.value.text),
      categoryId: _categoryId,
    );
    ItemModel.createItem(item, _image!);
    // var url = "${AppData.url}adddata.php";

    // http.post(Uri.parse(url), body: {
    //   "itemcode": controllerCode.text,
    //   "itemname": controllerName.text,
    //   "price": controllerPrice.text,
    //   "stock": controllerStock.text
    // });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    _categories = await Category.fetchAllCategories();
    _categories = _categories.toSet().toList(); // Remove duplicates
    setState(() {});
  }

  void error(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          style: TextStyle(
            fontFamily: 'Netflix',
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // _fetchCategories();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Add Data",
          style: TextStyle(fontFamily: "Netflix"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 80.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Tap to Add Photo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: controllerCode,
                  style: TextStyle(
                    fontFamily: "Netflix",
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: "Item Code",
                    hintStyle: TextStyle(fontFamily: "Netflix"),
                    labelText: "Item Code",
                    labelStyle: TextStyle(fontFamily: "Netflix"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: controllerName,
                  style: TextStyle(
                    fontFamily: "Netflix",
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: "Item Name",
                    hintStyle: TextStyle(fontFamily: "Netflix"),
                    labelText: "Item Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: controllerPrice,
                  style: TextStyle(
                    fontFamily: "Netflix",
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: "Price",
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: controllerStock,
                  style: TextStyle(
                    fontFamily: "Netflix",
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: "Stock",
                    labelText: "Stock",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                DropdownButtonFormField<Category>(
                  decoration: InputDecoration(
                    hintText: "Select Category",
                    labelText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            child: Text(
                              category.name,
                              style: TextStyle(fontFamily: "Netflix"),
                            ),
                            value: category,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoryId = value!.id!;
                      print(_categoryId);
                    });
                  },
                  value: _categories.isNotEmpty ? _categories[0] : null,
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Home();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Go Home",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                        minimumSize: Size(150, 50),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (controllerCode.value.text.isEmpty) {
                          setState(() {
                            error(context, "Item Code cannot be empty");
                          });
                        } else if (controllerCode.value.text
                            .contains(RegExp(r'[a-zA-Z]'))) {
                          setState(() {
                            error(context, "Item Code must be a number");
                            error(context, "Fill in the data correctly!");
                          });
                        } else if (controllerCode.value.text.length != 3) {
                          setState(() {
                            error(context, "Item Code must contain 3 digits");
                            error(context, "Fill in the data correctly!");
                          });
                        } else if (controllerName.value.text.isEmpty) {
                          setState(() {
                            error(context, "Item name cannot be empty");
                            error(context, "Fill in the data correctly!");
                          });
                        } else if (controllerName.value.text.length < 5) {
                          error(context,
                              "Item name must be at least 5 characters");
                          error(context, "Isi data dengan benar!");
                        } else if (controllerPrice.value.text.isEmpty) {
                          setState(() {
                            error(context, "Price cannot be empty");
                            error(context, "Fill in the data correctly!");
                          });
                        } else if (controllerPrice.value.text
                            .contains(RegExp(r'[a-zA-Z]'))) {
                          setState(() {
                            error(context, "Fill Price only with numbers");
                            error(context, "Fill in the data correctly!");
                          });
                        } else if (controllerPrice.value.text.length < 4) {
                          setState(() {
                            error(
                                context, "The price does not match the format");
                            error(context, "Fill in the data correctly!");
                          });
                        } else {
                          ItemModel.add_itmes(
                              controllerCode.value.text,
                              controllerName.value.text,
                              int.parse(controllerPrice.value.text),
                              int.parse(controllerStock.value.text),
                              _categoryId,
                              _image!);
                          // addData();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const showMessage();
                              },
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Add Data",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        minimumSize: Size(150, 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              controllerName.clear();
              controllerPrice.clear();
              controllerStock.clear();
              controllerCode.clear();
            });
          },
          backgroundColor: Colors.redAccent,
          child: Text("Clear")),
    );
  }
}

class showMessage extends StatelessWidget {
  const showMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text("Data has been added secssfully"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }
}
