import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'homepage.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => new _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController userController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
//////////////////////////////////////Roq Added it //////////////////////////////
  bool _visible = false;
  final _formKey = GlobalKey<FormState>();
  Future userLogin() async {
    //Login API URL
    //use your local IP address instead of localhost or use Web API
    String url = "http://10.0.2.2/my_store/user_login.php";
    // 10.0.2.2
    // Showing LinearProgressIndicator.
    setState(() {
      _visible = true;
    });

    // Getting username and password from Controller
    var data = {
      'username': userController.text,
      'password': pwdController.text,
    };

    //Starting Web API Call.
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    if (response.statusCode == 200) {
      //Server response into variable
      print(response.body);
      var msg = jsonDecode(response.body);

      //Check Login Status
      if (msg['loginStatus'] == true) {
        setState(() {
          //hide progress indicator
          _visible = false;
        });

        // Navigate to Home Screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        setState(() {
          //hide progress indicator
          _visible = false;

          //Show Error Message Dialog
          showMessage(msg["message"]);
        });
      }
    } else {
      setState(() {
        //hide progress indicator
        _visible = false;

        //Show Error Message Dialog
        showMessage("Error during connecting to Server.");
      });
    }
  }

  Future<dynamic> showMessage(String _msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 160,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Wrap(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    color: Colors.red[300],
                    child: Column(
                      children: <Widget>[
                        Container(height: 10),
                        Icon(Icons.cloud_off, color: Colors.white, size: 80),
                        Container(height: 10),
                        Text("Error !",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.white)),
                        Container(height: 10),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Text("$_msg",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Color(0xFF666666))),
                        Container(height: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0)),
                            backgroundColor: Colors.red[300],
                          ),
                          child: Text(
                            "Retry",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        /* AlertDialog(
          title: new Text(_msg),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );*/
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////
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

  bool password_visiable = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
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
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Theme(
                          data: new ThemeData(
                            primaryColor: Color.fromRGBO(84, 87, 90, 0.5),
                            primaryColorDark: Color.fromRGBO(84, 87, 90, 0.5),
                            hintColor: Color.fromRGBO(
                                84, 87, 90, 0.5), //placeholder color
                          ),
                          child: TextFormField(
                            controller: userController,
                            decoration: InputDecoration(
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(84, 87, 90, 0.5),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(84, 87, 90, 0.5),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              errorBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              labelText: 'Enter User Name',
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color.fromRGBO(84, 87, 90, 0.5),
                              ),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(84, 87, 90, 0.5),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              hintText: 'User Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter User Name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Theme(
                          data: new ThemeData(
                            primaryColor: Color.fromRGBO(84, 87, 90, 0.5),
                            primaryColorDark: Color.fromRGBO(84, 87, 90, 0.5),
                            hintColor: Color.fromRGBO(
                                84, 87, 90, 0.5), //placeholder color
                          ),
                          child: TextFormField(
                            controller: pwdController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(password_visiable
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    password_visiable = !password_visiable;
                                  });
                                },
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(84, 87, 90, 0.5),
                                  style: BorderStyle.none,
                                ),
                              ),
                              enabledBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(84, 87, 90, 0.5),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              errorBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(84, 87, 90, 0.5),
                                  style: BorderStyle.none,
                                ),
                              ),
                              labelText: 'Enter Password',
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color.fromRGBO(84, 87, 90, 0.5),
                              ),
                              hintText: 'Password',
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !password_visiable,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate())
                                {userLogin()}
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Submit',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
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
