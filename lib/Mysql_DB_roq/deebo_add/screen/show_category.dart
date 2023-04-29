import 'package:flutter/material.dart';

import '../model/categorys.dart';
import 'AddCategoryScreen.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      _categories = await Category.fetchAllCategories();
    } catch (error) {
      print(error);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showDeleteConfirmationDialog(Category category) async {
    final isDeleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this category?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (isDeleteConfirmed == true) {
      try {
        await Category.deleteCategory(category);
        _categories.remove(category);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category deleted'),
          ),
        );
        _fetchCategories();
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete category'),
          ),
        );
      }
    }
  }

  Future<void> _showEditDialog(Category category) async {
    final nameController = TextEditingController(text: category.name);
    final descriptionController =
        TextEditingController(text: category.description);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                final updatedCategory = Category(
                  id: category.id,
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                );
                try {
                  await Category.updateCategory(updatedCategory);
                  setState(() {
                    final index = _categories.indexOf(category);
                    _categories[index] = updatedCategory;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Category updated'),
                    ),
                  );
                } catch (error) {
                  print(error);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update category'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (BuildContext context, int index) {
                final category = _categories[index];
                return Card(
                  elevation: 3.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      category.name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(category.description,
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[600])),
                    trailing: Wrap(
                      spacing: 8.0,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(category),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _showDeleteConfirmationDialog(category),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CategoryForm();
          })).then((_) => _fetchCategories());
        },
      ),
    );
  }
}
