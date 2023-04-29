import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class add_items extends StatefulWidget {
  const add_items();

  @override
  // ignore: library_private_types_in_public_api
  _add_itemsState createState() => _add_itemsState();
}

class _add_itemsState extends State<add_items> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController controllerCode = TextEditingController();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPrice = TextEditingController();
  final TextEditingController controllerStock = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              _image == null
                  ? GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 80.0,
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          height: 200.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Change Image'),
                        ),
                      ],
                    ),
              SizedBox(height: 20.0),
              TextField(
                controller: controllerCode,
                style: TextStyle(fontFamily: "Netflix", fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Item Code",
                  hintStyle: TextStyle(fontFamily: "Netflix"),
                  labelText: "Item Code",
                  labelStyle: TextStyle(fontFamily: "Netflix"),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: controllerName,
                style: TextStyle(fontFamily: "Netflix", fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Item Name",
                  hintStyle: TextStyle(fontFamily: "Netflix"),
                  labelText: "Item Name",
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: controllerPrice,
                style: TextStyle(fontFamily: "Netflix", fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Price",
                  labelText: "Price",
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: controllerStock,
                style: TextStyle(fontFamily: "Netflix", fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Stock",
                  labelText: "Stock",
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Submit form data here
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
