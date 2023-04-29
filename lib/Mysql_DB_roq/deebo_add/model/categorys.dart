import 'package:http/http.dart' as http;
import 'dart:convert';

import '../appData.dart';

class Category {
  int? id;
  String name;
  String description;
  //var  apiurl = '${AppData.url}categories';
  Category({this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['id']),
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'description': description};

  static Future<List<Category>> fetchAllCategories() async {
    final response =
        await http.get(Uri.parse('${AppData.url}get_category.php'));
    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(response.body);
        return List<Category>.from(
          jsonData.map((category) => Category.fromJson(category)),
        );
      } catch (e) {
        throw Exception('Failed to parse category data: $e');
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<Category> fetchCategoryById(int id) async {
    final response =
        await http.get(Uri.parse('${AppData.url}search_category.php?id=$id'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body.replaceAll("<br />", ""));
      return Category.fromJson(jsonData);
    } else {
      throw Exception('Failed to load category with id=$id');
    }
  }

  static Future<String> getCategoryName(int id) async {
    final url = Uri.parse('${AppData.url}get_category_name.php?id=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['name'];
    } else {
      throw Exception('Failed to load category with id=$id');
    }
  }

  static Future<void> addCategory(Category category) async {
    final response = await http.post(
      Uri.parse('${AppData.url}categories.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(category),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add category');
    }
  }

  static Future<void> updateCategory(Category category) async {
    final response = await http.put(
      Uri.parse('${AppData.url}categories.php/${category.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(category),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update category with id=${category.id}');
    }
  }

  static Future<void> deleteCategory(Category category) async {
    final response = await http.delete(
        Uri.parse('${AppData.url}delete_category.php/${category.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode != 204) {
      throw Exception('Failed to delete category with id=${category.id}');
    }
  }
}
