import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String description;

  Category({required this.id, required this.name, required this.description});
}

class CategoryDropdown extends StatefulWidget {
  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  late List<Category> _categories;
  late int _selectedCategory;

  @override
  void initState() {
    super.initState();
    // fetch categories from database or API and populate _categories list
    _categories = [
      Category(id: 1, name: 'Category A', description: 'Description A'),
      Category(id: 2, name: 'Category B', description: 'Description B'),
      Category(id: 3, name: 'Category C', description: 'Description C'),
    ];
    // set default selected category to the first category in the list
    _selectedCategory = _categories[0].id;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        hintText: "Select Category",
        labelText: "Category",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      items: _categories
          .map((category) => DropdownMenuItem<int>(
                child: Text(
                  category.name,
                  style: TextStyle(fontFamily: "Netflix"),
                ),
                value: category.id,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
      value: _selectedCategory,
    );
  }
}
