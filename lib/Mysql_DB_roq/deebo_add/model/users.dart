import 'dart:convert';

import 'package:http/http.dart' as http;

import '../appData.dart';

class User {
  final int uid;
  final String name;
  final String uname;
  final String upass;

  User(
      {required this.uid,
      required this.name,
      required this.uname,
      required this.upass});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['UID'],
      name: json['NAME'],
      uname: json['UNAME'],
      upass: json['UPASS'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'uname': uname,
        'upass': upass,
      };
}

class AuthService {
  static Future<User> signUp(String? name, String? uname, String? upass) async {
    final response =
        await http.post(Uri.parse('${AppData.url}signup.php'), body: {
      'name': name,
      'uname': uname,
      'upass': upass,
    });
    final jsonBody = json.decode(response.body);
    if (jsonBody['success']) {
      return User.fromJson(jsonBody['user']);
    } else {
      throw Exception(jsonBody['message']);
    }
  }

  static Future<User?> signIn(String uname, String upass) async {
    final response =
        await http.post(Uri.parse('${AppData.url}login.php'), body: {
      'username': uname,
      'password': upass,
    });
    final jsonBody = json.decode(response.body);
    if (jsonBody['success']) {
      return User.fromJson(jsonBody['user']);
    } else {
      print(jsonBody['message']);
      return null;
    }
  }
}
