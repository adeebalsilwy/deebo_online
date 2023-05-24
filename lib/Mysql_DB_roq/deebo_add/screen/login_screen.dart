// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../sample2_curdPages_roq/homepage.dart';
import '../button/signUp_button.dart';
import '../kConst.dart';
import '../model/users.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  TextEditingController _password = TextEditingController();
  TextEditingController _user_name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 48.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  'خطأ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    controller: _user_name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل اسم المستخدم';
                      }
                      return null;
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
                        Icons.verified_user,
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
                    controller: _password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        ;
                        return 'ادخل كلمه المرور';
                      }
                      return null;
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
                      String userName = _user_name.text;
                      String password = _password.text;
                      // Call the signIn method to authenticate the user's data with the server
                      final user = await AuthService.signIn(userName, password);

                      if (user == null) {
                        // Show an error message if the sign-in fails
                        _showErrorDialog(
                            context, 'اسم المستخدم أو كلمة المرور غير صحيحة');
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
