import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Login.dart';
import 'package:aungkomin_ap_assignment/Config/sys_variable.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isFailed = false;

  @override
  void initState() {
    setState(() {
      isFailed = false;
    });
    super.initState();
  }

  void userRegister(username, email, password, position) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          position.isNotEmpty) {
        var regBody = {
          "name": username,
          "email": email,
          "password": password,
          "position": position
        };

        var response = await http.post(
          Uri.parse('http://$server_add:$server_port/user/register'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          print(jsonResponse['success']);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          print('Register Failed');
          setState(() {
            isFailed = true;
          });
        }
      } else {
        print('Invalid Information');
        setState(() {
          isFailed = true;
        });
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
          automaticallyImplyLeading: false,
          backgroundColor: pri_color,
          title: const Text(
            'RMS',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: isFailed
            ? RegisterFail(
                ontry: () => {
                  setState(() {
                    isFailed = false;
                  })
                },
              )
            : RegisterForm(
                onRegister: (u, e, p, po) => userRegister(u, e, p, po)));
  }
}

class RegisterForm extends StatefulWidget {
  final Function(String u, String e, String p, String po) onRegister;
  RegisterForm({Key? key, required this.onRegister}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController uname_textcontrol = TextEditingController();

  final TextEditingController email_textcontrol = TextEditingController();

  final TextEditingController password_textcontrol = TextEditingController();

  final TextEditingController posi_textcontrol = TextEditingController();

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
                    controller: uname_textcontrol,
                    decoration: const InputDecoration(
                        hintText: 'Username',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: pri_color,
                        ))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: email_textcontrol,
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
                    controller: posi_textcontrol,
                    decoration: const InputDecoration(
                        hintText: 'Position',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: pri_color,
                        ))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: password_textcontrol,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: pri_color,
                        ))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pri_color,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text(
                        'Register',
                        style: TextStyle(color: sec_color, fontSize: 17),
                      ),
                    ),
                    onPressed: () {
                      widget.onRegister(
                        uname_textcontrol.text,
                        email_textcontrol.text,
                        password_textcontrol.text,
                        posi_textcontrol.text,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: const Text('Have account? Login',
                          style: TextStyle(color: pri_color))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterFail extends StatelessWidget {
  const RegisterFail({Key? key, required this.ontry}) : super(key: key);
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
                    'Registration Failed',
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
