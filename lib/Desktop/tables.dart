import 'dart:convert';

import 'package:aungkomin_ap_assignment/Screens/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Config/sys_variable.dart';

class Tables extends StatefulWidget {
  final Function(String id) onTaken;
  const Tables(this.onTaken, {Key? key}) : super(key: key);

  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  List<dynamic>? tableList;

  @override
  void initState() {
    getTables();
    super.initState();
  }

  Future<void> getTables() async {
    try {
      final response = await http.get(
        Uri.parse('http://$server_add:$server_port/tables/get'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          tableList = jsonResponse['success'];
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateData(String id, int seats, String type, bool taken) async {
    try {
      var regBody = {"id": id, "seats": seats, "type": type, "taken": !taken};

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/tables/update'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          tableList = jsonResponse['success'];
        });
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      color: thi_color,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: tableList == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Wrap(
                spacing: 20,
                children: [
                  for (var table in tableList!) ...[
                    Container(
                      width: 220,
                      height: 200,
                      color: sec_color,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            table!['id'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: pri_color),
                          ),
                          Text('Seats : ${table['seats']}'),
                          Text(table!['taken'] ? 'Taken' : 'Available'),
                          ElevatedButton(
                              onPressed: () {
                                updateData(table!['id'], table['seats'],
                                    table['type'], table['taken']);
                                widget.onTaken(table['id']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: table['taken']
                                    ? preserved_table_color
                                    : pri_color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child:
                                    Text(table!['taken'] ? 'Cancel' : 'Take'),
                              ))
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
    );
  }
}
