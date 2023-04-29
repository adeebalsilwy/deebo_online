import 'package:flutter/material.dart';
import '../deebo_add/add_items.dart';
import '../deebo_add/appData.dart';
import '../deebo_add/model/categorys.dart';
import '../deebo_add/model/items.dart';
import 'Detail.dart';
import 'adddata.dart';
import 'homepage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int _selectedCategoryId = 0;
  List<Category> _categories = [];

  Future<void> _fetchCategories() async {
    try {
      _categories = await Category.fetchAllCategories();
    } catch (error) {
      print(error);
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  void _onCategoryTap(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  void _onAllItemsTap() {
    setState(() {
      _selectedCategoryId = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Data Inventory",
          style: TextStyle(fontFamily: "Netflix"),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AddData();
                  }),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Privacy"),
              ),
              PopupMenuItem(
                child: Text("Settings"),
              ),
              PopupMenuItem(
                child: Text("About us"),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: "logout",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(),
                ),
              );
            },
            label: const Text('Menu'),
            icon: const Icon(Icons.logout),
            backgroundColor: Colors.blue,
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            heroTag: "add data",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => AddData(),
                ),
              );
            },
            label: const Text('Add Data'),
            icon: const Icon(Icons.add_box),
            backgroundColor: Colors.pink,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder<List<Category>>(
              future: Category.fetchAllCategories(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Category>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching categories'),
                  );
                } else {
                  List<Category>? categories = snapshot.data;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: _onAllItemsTap,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "All",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: _selectedCategoryId == 0
                                      ? Colors.blue
                                      : Colors.grey),
                            ),
                          ),
                        ),
                        for (Category category in categories!)
                          InkWell(
                            onTap: () => _onCategoryTap(category.id!),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.name,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: _selectedCategoryId == category.id
                                        ? Colors.blue
                                        : Colors.grey),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: _selectedCategoryId == 0
                  ? ItemModel.fetchAll()
                  : ItemModel.fetchItemsByCategoryId(_selectedCategoryId),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching items'),
                  );
                } else {
                  List<Item> items = snapshot.data!;
                  return ItemList(itemList: items);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class name extends StatelessWidget {
//   const name({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: items.length,
//       itemBuilder: (BuildContext context, int index) {
//         Item item = items[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => Detail(
//                   list: items,
//                   index: index,
//                 ),
//               ),
//             );
//           },
//           child: Card(
//             margin: EdgeInsets.all(8),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.itemName,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(item.itemCode),
//                   SizedBox(height: 8),
//                   Text(
//                     item.price.toStringAsFixed(2),
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class ItemList extends StatelessWidget {
  final List<Item> itemList;
  ItemList({required this.itemList});

  Widget _buildText(int id) {
    return FutureBuilder<String>(
      future: Category.getCategoryName(id),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          // If the Future has completed successfully, display the text
          return Text(snapshot.data!);
        } else if (snapshot.hasError) {
          // If there was an error while fetching the data, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // While the Future is still running, display a loading spinner
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = itemList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail(
                  list: itemList,
                  index: index,
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: item.imagePro != null
                              ? Image.network(
                                  '${AppData.url + item.imagePro!}',
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image),
                        ),
                      ),
                    ),
                    title: Text(
                      '${item.itemName}',
                      style: TextStyle(
                        fontFamily: 'Netflix',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${item.price}',
                      style: TextStyle(
                        fontFamily: 'Netflix',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// return ListView.builder(
//       itemCount: itemList.length,
//       itemBuilder: (context, index) {
//         final item = itemList[index];
//         final backgroundColor =
//             index % 2 == 0 ? Colors.grey[100] : Colors.white;

//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//             elevation: 2.0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: InkWell(
//               onTap: () => Navigator.of(context).push(
//                 PageRouteBuilder(
//                   transitionDuration: Duration(milliseconds: 500),
//                   pageBuilder: (context, animation, secondaryAnimation) =>
//                       Detail(
//                     list: itemList,
//                     index: index,
//                   ),
//                   transitionsBuilder:
//                       (context, animation, secondaryAnimation, child) {
//                     return FadeTransition(
//                       opacity: animation,
//                       child: child,
//                     );
//                   },
//                 ),
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(16.0),
//                 color: backgroundColor,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ListTile(
//                       leading: Expanded(
//                         flex: 3,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: AspectRatio(
//                             aspectRatio: 1,
//                             child: item.imagePro != null
//                                 ? Image.network(
//                                     '${AppData.url + item.imagePro!}',
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Icon(Icons.image),
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         'items_name${item.itemName}',
//                         style: TextStyle(
//                           fontFamily: 'Netflix',
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle: Text(
//                         'items_price${item.itemName}',
//                         style: TextStyle(
//                           fontFamily: 'Netflix',
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.redAccent,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
