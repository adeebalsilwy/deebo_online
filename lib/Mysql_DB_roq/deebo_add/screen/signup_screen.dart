// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'package:flutter/material.dart';

import '../../sample2_curdPages_roq/homepage.dart';
import '../button/signUp_button.dart';
import '../kConst.dart';
import '../model/users.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  String? _name;
  String? _password;
  String? user_name;
  TextEditingController nameController = new TextEditingController();

  TextEditingController userController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();

  SignUpScreen({super.key});

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
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 48.0,
                ),
                SizedBox(height: 20.0),
                Text(
                  'هناك خطأ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  child: Text(
                    'دخول',
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
          child: Center(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'انشاء حساب',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'bold',
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Image.asset(
                    'asset/signups.png',
                    width: MediaQuery.of(context).size.width - 30,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(right: 15, left: 15, bottom: 10),
                    decoration: kTextContainerForm,
                    child: TextFormField(
                      controller: nameController,
                      maxLength: 20,
                      onChanged: (value) => {_name = value},
                      onSaved: (value) {
                        _name = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب ادخال الاسم الكامل ';
                        }
                        return null;
                      },
                      cursorColor: Colors.deepPurpleAccent[900],
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: 'الاسم الكامل',
                        hintStyle: hintStyleLoginScreen,
                        icon: Icon(
                          Icons.person,
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
                      controller: userController,
                      maxLength: 30,
                      onChanged: (value) => {user_name = value},
                      onSaved: (value) {
                        user_name = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب ادخال  اسم المستخدم';
                        }

                        return null;
                      },
                      cursorColor: Colors.deepPurpleAccent[900],
                      keyboardType: TextInputType.emailAddress,
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
                      controller: pwdController,
                      maxLength: 15,
                      obscureText: true,
                      onChanged: (value) => {_password = value},
                      onSaved: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب ادخال كلمه المرور';
                        }

                        if (value.length < 4) {
                          return 'كلمه المرور يجب ان تكزن اكبر من 4';
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
                      text: 'حفظ',
                      onTap: () async {
                        // Validate the form fields
                        if (!_key.currentState!.validate()) {
                          return;
                        }

                        // Save the form data
                        _key.currentState!.save();
                        _name = nameController.text;
                        _password = pwdController.text;
                        user_name = userController.text;
                        // Call the signUp method to save the user's data to the server
                        final user = await AuthService.signUp(
                            _name, user_name, _password);

                        if (user == null) {
                          // Show an error message if the sign-up fails
                          _showErrorDialog(context, 'حدث خطأ أثناء التسجيل');
                        } else {
                          // Navigate to the home page if the sign-up is successful
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      }),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'هل لديك حساب ؟',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'bold',
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Color(0xFF6A3899),
                            fontFamily: 'bold',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final kTextContainerForm = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.deepPurple[100],
  );
}
