import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'homepage.dart';

class LoginForm_Simple extends StatefulWidget {
  @override
  _LoginForm_SimpleState createState() => new _LoginForm_SimpleState();
}

class _LoginForm_SimpleState extends State<LoginForm_Simple> {
  TextEditingController controllerusername = new TextEditingController();
  TextEditingController controllerpassword = new TextEditingController();

  void error(BuildContext context, String error) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(error),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Image(image: AssetImage("images/login.png")),
                Text(
                  "Login Form",
                  style: TextStyle(fontFamily: "Netflix", fontSize: 20),
                ),
                new TextField(
                  controller: controllerusername,
                  style: TextStyle(fontFamily: "Netflix"),
                  decoration: new InputDecoration(
                      hintText: "Username", labelText: "Username"),
                ),
                // new TextField(
                //  controller: controllerPrice,
                // style: TextStyle(fontFamily: "Netflix", fontSize: 15),
                //decoration: new InputDecoration(
                //  hintText: "Price", labelText: "Price"),
                // ),
                new TextField(
                  style: TextStyle(
                    fontFamily: "Netflix",
                  ),
                  controller: controllerpassword,
                  obscureText: true,
                  enableSuggestions: false,
                  decoration: new InputDecoration(
                      hintText: "Password", labelText: "Password"),
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: new ElevatedButton(
                    onPressed: () {
                      if (controllerusername.value.text == 'deebo' &&
                          controllerpassword.value.text == 'deebo') {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }));
                        // _sendDataToSecondScreen(context);
                      } else if (controllerusername.value.text == 'jory' &&
                          controllerpassword.value.text == 'jory') {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }));
                        // _sendDataToSecondScreen(context);
                      } else if (controllerusername.value.text == 'joan' &&
                          controllerpassword.value.text == 'joanpass') {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }));
                        // _sendDataToSecondScreen(context);
                      } else {
                        error(context, "Wrong username and password!");
                      }
                    },
                    child: new Text(
                      "Login",
                      style:
                          TextStyle(fontFamily: "Netflix", color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// void _sendDataToSecondScreen(BuildContext context) {
//     String textToSend = controllerusername.text;
//     Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(text: textToSend,),
//         ));
//   }
}
