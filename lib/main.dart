import 'package:aungkomin_ap_assignment/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'Desktop/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
      MyApp(token: prefs.getString('token'), email: prefs.getString('email')));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.token, this.email});
  final token;
  final email;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (token != null &&
              JwtDecoder.isExpired(token) == false &&
              email != null)
          ? Home(email: email)
          : Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}