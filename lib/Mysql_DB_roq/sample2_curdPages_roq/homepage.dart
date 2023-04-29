import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../deebo_add/screen/AddCategoryScreen.dart';
import '../deebo_add/screen/login_screen.dart';
import '../deebo_add/screen/show_category.dart';
import 'listdata.dart';
import 'loginform.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _uname = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 30,
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                'Welcome, $_uname admin',
                style: const TextStyle(
                  fontFamily: 'Netflix',
                  fontSize: 18,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Image(image: AssetImage('images/dashboard.png')),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CategoryListScreen();
                }));
              },
              child: Text(
                ' categorys',
                style:
                    const TextStyle(fontFamily: 'Netflix', color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Home();
                }));
              },
              child: Text(
                'View Data',
                style:
                    const TextStyle(fontFamily: 'Netflix', color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(
                'Logout',
                style:
                    const TextStyle(fontFamily: 'Netflix', color: Colors.white),
              ),
              onPressed: () {
                logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You have successfully logged out!'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }
}
