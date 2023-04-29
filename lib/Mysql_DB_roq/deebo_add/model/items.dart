// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../appData.dart';

class Item {
  int? id;
  String itemCode;
  String itemName;
  int price;
  int stock;
  int categoryId;
  String? imagePro;

  Item({
    this.id,
    required this.itemCode,
    required this.itemName,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.imagePro,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: int.parse(json['id'].toString()),
      itemCode: json['item_code'].toString(),
      itemName: json['item_name'].toString(),
      price: int.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      categoryId: int.parse(json['category_id'].toString()),
      imagePro: json['image_pro'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'item_code': itemCode,
        'item_name': itemName,
        'price': price,
        'stock': stock,
        'category_id': categoryId,
        'image_pro': imagePro,
      };
}

class ItemModel {
  static const String apiUrl = '${AppData.url}get_items.php';

  static Future<List<Item>> fetchAll() async {
    final response = await http.get(Uri.parse('${AppData.url}getdata.php'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List;
      return jsonData.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<void> add_itmes(String itemCode, String itemName, int price,
      int stock, int categoryId, File imagePro) async {
    final url = Uri.parse('${AppData.url}add_items.php');

    var request = http.MultipartRequest('POST', url);

    // Add the form data to the request
    request.fields.addAll({
      'itemCode': itemCode,
      'itemName': itemName,
      'price': price.toString(),
      'stock': stock.toString(),
      'category_id': categoryId.toString(),
    });

    // Add the image file to the request
    var file = await http.MultipartFile.fromPath('imagePro', imagePro.path);
    request.files.add(file);

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.transform(utf8.decoder).join();
      var data = jsonDecode(responseData);

      // Handle response from server
      if (data['id'] != null) {
        // Item created successfully
        print('Item created with ID: ${data['id']}');
      } else {
        // Failed to create item
        throw Exception('Failed to create item.');
      }
    } else {
      // Failed to create item
      throw Exception('Failed to create item.');
    }
  }

  static Future<void> update_items(int id, String itemCode, String itemName,
      int price, int stock, int categoryId, File? imagePro) async {
    final url = Uri.parse('${AppData.url}editdata.php?id=$id');
    var request = http.MultipartRequest('POST', url);

    // Add the form data to the request
    request.fields.addAll({
      'itemCode': itemCode,
      'itemName': itemName,
      'price': price.toString(),
      'stock': stock.toString(),
      'category_id': categoryId.toString(),
    });

    // Add the image file to the request
    if (imagePro != null) {
      var file = await http.MultipartFile.fromPath('imagePro', imagePro.path);
      request.files.add(file);
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.transform(utf8.decoder).join();

      try {
        var data = jsonDecode(responseData);

        // Handle response from server
        if (data['id'] != null) {
          // Item created successfully
          print('Item updates  with ID: ${data['id']}');
        } else {
          // Failed to create item
          throw Exception('Failed to create item.');
        }
      } catch (e) {
        // Failed to decode response
        throw Exception('Failed to decode response.');
      }
    } else {
      // Failed to create item
      throw Exception('Failed to create item.');
    }
  }

  static Future<Item> fetchById(int id) async {
    final response = await http.get('${AppData.url}/$id' as Uri);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Item.fromJson(jsonData);
    } else {
      throw Exception('Failed to load item with id=$id');
    }
  }

  static Future<void> createItem(Item item, File imageFile) async {
    final url = Uri.parse('${AppData.url}add_items.php');

    try {
      var request = http.MultipartRequest('POST', url);
      // Add the form data to the request
      request.fields.addAll({
        'item_code': item.itemCode,
        'item_name': item.itemName,
        'price': item.price.toString(),
        'stock': item.stock.toString(),
        'category_id': item.categoryId.toString(),
      });

      // Add the image file to the request
      var file = await http.MultipartFile.fromPath('imagePro', imageFile.path);
      request.files.add(file);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.transform(utf8.decoder).join();
        var data = jsonDecode(responseData);
        // Handle response from server
        if (data['id'] != null) {
          // Item created successfully
          print('Item created with ID: ${data['id']}');
        } else {
          // Failed to create item
          //throw Exception('Failed to create item.');
        }
      } else {
        // Failed to create item
        print('Failed to create item.');
      }
    } catch (e) {
      // Handle error
      print('Failed to create item: $e');
      //rethrow;
    }
  }
  // if (imageFile != null) {
  //   // Define the target directory and filename
  //   const targetDir = "images/";
  //   final targetFile = targetDir + imageFile.path.split('/').last;

  //   // Upload the file to the server
  //   final request = http.MultipartRequest('POST', url);
  //   final file =
  //       await http.MultipartFile.fromPath('imagePro', imageFile.path);
  //   request.files.add(file);
  //   final response = await request.send();

  //   if (response.statusCode == 200) {
  //     item.imagePro = targetFile;
  //   } else {
  //     throw Exception('Failed to upload image.');
  //   }
  // }

  // final response = await http.post(
  //   url,
  //   body: item.toJson(),
  // );

  // if (response.statusCode == 200) {
  //   return Item.fromJson(jsonDecode(response.body));
  // } else {
  //   throw Exception('Failed to create item.');
  // }

  static Future<List<Item>> fetchItemsByCategoryId(int categoryId) async {
    final response = await http.get(Uri.parse(
        '${AppData.url}fetch_category_id.php?categoryId=$categoryId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Item>.from(jsonData.map((item) => Item.fromJson(item)));
    } else {
      throw Exception('Failed to load items for category with id=$categoryId');
    }
  }
}
