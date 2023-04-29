// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../deebo_add/appData.dart';
import '../deebo_add/model/categorys.dart';
import '../deebo_add/model/items.dart';
import './editdata.dart';
import 'listdata.dart';

class Detail extends StatefulWidget {
  final List<Item> list;
  final int index;

  Detail({required this.index, required this.list});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String categoryName = "";
  late String imageProUrl;
  Widget _buildText(int id) {
    return FutureBuilder<String>(
      future: Category.getCategoryName(id),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          // If the Future has completed successfully, display the text
          return Text('category : ${snapshot.data!}');
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

  // void getCategoryName() {
  //   setState(() {
  //     categoryName = _buildText(widget.list[widget.index].categoryId);
  //   });
  // }

  void getImageProUrl() {
    setState(() {
      imageProUrl = "${AppData.url}${widget.list[widget.index].imagePro}";
    });
  }

  void deleteData() async {
    var url = "${AppData.url}deleteData.php";
    await http.post(Uri.parse(url),
        body: {'id': widget.list[widget.index].id.toString()});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Data deleted successfully'),
        action: SnackBarAction(
            label: 'OK',
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar),
      ),
    );

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Home();
    }));
  }

  @override
  void initState() {
    // getCategoryName();
    getImageProUrl();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.list[widget.index].itemName,
          style: const TextStyle(fontFamily: "Netflix"),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                ),
                Text(
                  widget.list[widget.index].itemName,
                  style: const TextStyle(fontFamily: "Netflix", fontSize: 20.0),
                ),
                Text(
                  "Code: ${widget.list[widget.index].itemCode}",
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  "Price: ${widget.list[widget.index].price}.RY",
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  "Stock: ${widget.list[widget.index].stock}",
                  style: const TextStyle(fontSize: 18.0),
                ),
                _buildText(widget.list[widget.index].categoryId),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    height: 200,
                    child: Image.network(
                      imageProUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: OutlinedButton(
                        child: const Text(
                          "EDIT",
                          style: TextStyle(
                              fontFamily: "Netflix", color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return EditData(
                            list: widget.list[widget.index],
                            index: widget.index,
                          );
                        })),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: OutlinedButton(
                        child: const Text(
                          "DELETE",
                          style: TextStyle(
                              fontFamily: "Netflix", color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text("Delete Data"),
                                    content: const Text(
                                        "Are you sure you want to delete this data?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                          deleteData();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
