import 'dart:convert';

import 'package:aungkomin_ap_assignment/Desktop/kitchen.dart';
import 'package:aungkomin_ap_assignment/Desktop/order.dart';
import 'package:aungkomin_ap_assignment/Desktop/reporting.dart';
import 'package:aungkomin_ap_assignment/Desktop/tables.dart';
import 'package:flutter/material.dart';
import 'package:aungkomin_ap_assignment/Screens/theme.dart';
import 'package:aungkomin_ap_assignment/Config/sys_variable.dart';
import 'configuration.dart';
import 'menu.dart';
import '../Screens/Login.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Home extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var email;
  Home({Key? key, required this.email}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedPage = 'Tables';
  String selectedTableId = '';
  String currentStage = '';
  bool additionalOrder = false;
  String name = '';

  @override
  void initState() {
    fetchUser();
    setState(() {
      additionalOrder = false;
    });
    super.initState();
  }

  void fetchUser() async {
    try {
      var regBody = {"email": widget.email};

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/user/check'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        // print(jsonResponse['success'].toString());
        setState(() {
          name = jsonResponse['success']['name'];
        });
      }
    } catch (err) {
      print('Error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> destinations = {
      'Tables': Tables((id) => {
            setState(() {
              selectedTableId = id;
            })
          }),
      'Menu': Menu(selectedTableId, currentStage, additionalOrder),
      'Orders': OrdersPipeline(
        goBackMenu: (id, stage) {
          setState(() {
            selectedTableId = id;
            currentStage = stage;
            additionalOrder = true;
            selectedPage = 'Menu';
          });
        },
      ),
      'Kitchen': const KitchenDashboard(),
      'Reporting': const Reporting(),
      'Configuration': const Configuration(),
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pri_color,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    'RMS',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                for (var desi in destinations.keys) ...[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedPage = desi;
                      });
                    },
                    child: Text(
                      desi,
                      style: navItemStyle,
                    ),
                  )
                ],
                TextButton(
                  onPressed: () {},
                  child: Text(
                    name,
                    style: navItemStyle,
                  ),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  'Log out',
                  style: navItemStyle,
                ))
          ],
        ),
      ),
      body: destinations[selectedPage]!,
    );
  }
}
