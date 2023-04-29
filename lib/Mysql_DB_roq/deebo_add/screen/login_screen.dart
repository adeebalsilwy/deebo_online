import 'package:flutter/material.dart';

import '../../sample2_curdPages_roq/homepage.dart';
import '../button/signUp_button.dart';
import '../kConst.dart';
import '../model/users.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  String? _password;
  String? _user_name;

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('هناك خطا'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('دخول'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'مرحبا بك ',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'bold',
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Image.asset(
                  'asset/logins.png',
                  width: MediaQuery.of(context).size.width - 30,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(right: 15, left: 15, bottom: 10),
                  decoration: kTextContainerForm,
                  child: TextFormField(
                    maxLength: 30,
                    onChanged: (value) => {_user_name = value},
                    onSaved: (value) {
                      _user_name = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل اسم المستخدم';
                      }
                    },
                    cursorColor: Colors.deepPurpleAccent[900],
                    keyboardType: TextInputType.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: 'اسم المستخدم ',
                      hintStyle: hintStyleLoginScreen,
                      icon: Icon(
                        Icons.alternate_email,
                        color: Color(0xFF6A3899),
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(right: 15, left: 15, bottom: 10),
                  decoration: kTextContainerForm,
                  child: TextFormField(
                    maxLength: 15,
                    style: Theme.of(context).textTheme.bodyText1,
                    obscureText: true,
                    onChanged: (value) => {_password = value},
                    onSaved: (value) {
                      _password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        ;
                        return 'ادخل كلمه المرور';
                      }
                    },
                    cursorColor: Colors.deepPurpleAccent[900],
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: 'كلمه المرور',
                      hintStyle: hintStyleLoginScreen,
                      icon: Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF6A3899),
                        size: 25,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SignUpButton(
                  text: 'تسجيل الدخول',
                  onTap: () async {
                    if (_key.currentState!.validate()) {
                      // Save the form data
                      _key.currentState!.save();
                      String userName = _user_name!;
                      String password = _password!;
                      // Call the signIn method to authenticate the user's data with the server
                      final user = await AuthService.signIn(userName, password);

                      if (user == null) {
                        // Show an error message if the sign-in fails
                        _showErrorDialog(
                            'اسم المستخدم أو كلمة المرور غير صحيحة');
                      } else {
                        // Navigate to the home page if the sign-in is successful
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لديك حساب ؟',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'bold',
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'التسجيل الان',
                        style: TextStyle(
                          color: Color(0xFF6A3899),
                          fontFamily: 'bold',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
