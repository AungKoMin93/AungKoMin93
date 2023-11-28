import 'dart:convert';

import 'package:aungkomin_ap_assignment/Desktop/sysConfig.dart';
import 'package:aungkomin_ap_assignment/Desktop/tableConfig.dart';
import 'package:aungkomin_ap_assignment/Desktop/userConfig.dart';
import 'package:aungkomin_ap_assignment/Config/sys_variable.dart';
import 'package:flutter/material.dart';
import 'package:aungkomin_ap_assignment/Screens/theme.dart';
import 'package:http/http.dart' as http;
import 'itemConfig.dart';

class Configuration extends StatefulWidget {
  const Configuration({Key? key}) : super(key: key);

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  String selectedConfig = 'Tables configuration';
  var logList = [];

  @override
  void initState() {
    getLogsList();
    super.initState();
  }

  void getLogsList() async {
    try {
      final response = await http.get(
        Uri.parse('http://$server_add:$server_port/logs/get'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          logList = jsonResponse['success'];
          var logListReversed = logList.reversed;
          logList = logListReversed.toList();
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (err) {
      print('Error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, Widget> configOptions = {
      'Tables configuration': TableConfig(),
      'Item configuration': ItemConfig(
        onChange: () => getLogsList(),
      ),
      'User configuration': const UserConfig(),
      'System configuration': const SystemConfig(),
    };

    return Container(
      color: thi_color,
      width: screenWidth,
      height: screenHeight,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: sec_color,
            width: screenWidth / 4 - 30,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Configuration',
                  style: TextStyle(fontSize: headingSize),
                ),
                const SizedBox(
                  height: 20,
                ),
                for (var config in configOptions.keys) ...[
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        config,
                        style: selectedConfig == config
                            ? activeStyle
                            : normalStyle,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedConfig = config;
                      });
                    },
                  ),
                ]
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: sec_color,
                    padding: const EdgeInsets.all(20),
                    child: configOptions[selectedConfig],
                  ),
                  Container(
                      color: sec_color,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Activities Log',
                            style: TextStyle(fontSize: headingSize),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          for (int i = 0; i < logList.length; i++) ...[
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                color: Colors.white,
                                child: Text(logList[i]['name'])),
                          ]
                        ],
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
