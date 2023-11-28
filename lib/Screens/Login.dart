import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Desktop/home.dart';
import 'theme.dart';
import 'Register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aungkomin_ap_assignment/Config/sys_variable.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SharedPreferences prefs;
  bool isFailed = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFailed = false;
      initSharedPref();
    });
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void userLogin(email, password) async {
    try {
      var regBody = {"email": email, "password": password};

      var response = await http.post(
          Uri.parse('http://$server_add:$server_port/user/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        var token = jsonResponse['token'];
        var email = jsonResponse['success']['email'];
        prefs.setString('token', token);
        prefs.setString('email', email);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      email: email,
                    )));
      }
    } catch (err) {
      print('Error: $err');
      setState(() {
        isFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'RMS',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: pri_color,
          automaticallyImplyLeading: false,
        ),
        body: isFailed
            ? LoginFail(
                ontry: () => {
                      setState(() {
                        isFailed = false;
                      })
                    })
            : LoginForm(onLogin: userLogin));
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key, required this.onLogin}) : super(key: key);
  final Function(String e, String p) onLogin;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double ScreenHeight = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: ScreenWidth,
      height: ScreenHeight,
      color: thi_color,
      alignment: Alignment.center,
      child: SizedBox(
        width: ScreenWidth > ScreenHeight ? ScreenWidth / 3 : null,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              color: sec_color,
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'RMS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: pri_color),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: pri_color,
                          ))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: pri_color,
                          ))),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pri_color,
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Text(
                          'Login',
                          style: TextStyle(color: sec_color, fontSize: 17),
                        ),
                      ),
                      onPressed: () {
                        widget.onLogin(
                            emailController.text, passwordController.text);
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextButton(
                      child: const Text(
                        'New User? Register',
                        style: TextStyle(color: pri_color),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginFail extends StatelessWidget {
  const LoginFail({Key? key, required this.ontry}) : super(key: key);
  final Function() ontry;

  @override
  Widget build(BuildContext context) {
    double ScreenHeight = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: ScreenWidth,
      height: ScreenHeight,
      color: thi_color,
      alignment: Alignment.center,
      child: SizedBox(
        width: ScreenWidth > ScreenHeight ? ScreenWidth / 3 : null,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              color: sec_color,
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                      height: 100,
                      width: 100,
                      child: Image(image: AssetImage('assets/password.png'))),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Login Failed',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: pri_color),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text(
                        'Try Again',
                        style: TextStyle(color: sec_color),
                      ),
                    ),
                    onPressed: () {
                      ontry();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
