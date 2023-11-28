import 'dart:convert';

import 'package:aungkomin_ap_assignment/Screens/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Config/sys_variable.dart';

class Reporting extends StatefulWidget {
  const Reporting({super.key});

  @override
  State<Reporting> createState() => _ReportingState();
}

class _ReportingState extends State<Reporting> {
  var selectedView = 'list';

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> views = {
      "list": const ListDisplay(),
      "graph": const GraphView()
    };

    return Container(
        color: thi_color,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.sort_rounded),
                    tooltip: 'Sort',
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedView = 'list';
                          });
                        },
                        icon: const Icon(
                          Icons.list,
                        ),
                        tooltip: 'Report Lists',
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedView = 'graph';
                          });
                        },
                        icon: const Icon(Icons.pie_chart),
                        tooltip: 'Data Insights',
                      )
                    ],
                  ),
                ],
              ),
            ),
            views[selectedView]!,
          ],
        ));
  }
}

class ListDisplay extends StatefulWidget {
  const ListDisplay({super.key});

  @override
  State<ListDisplay> createState() => _ListDisplayState();
}

class _ListDisplayState extends State<ListDisplay> {
  var reportData = [];
  double total = 0;
  bool totalAscend = true;
  bool dateAscend = true;

  void fetchReportData() async {
    try {
      final response = await http.get(
          Uri.parse('http://$server_add:$server_port/reports/get'),
          headers: {"Content-Type": "application/json"});

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        final data = jsonResponse['success'];
        final updatedData = <Map<String, dynamic>>[];
        double entryTotal = 0;

        for (var rd in data) {
          final order = rd["order"];
          final total = rd['total'];
          final newOrder = [];

          for (var item in order) {
            final foodId = item["food_id"];
            final quantity = item["quantity"];
            final itemDataResponse = await http.post(
                Uri.parse('http://$server_add:$server_port/items/getById'),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({"id": foodId}));

            final jsonItemDataResponse = jsonDecode(itemDataResponse.body);
            final itemName = jsonItemDataResponse['success']['name'];
            newOrder.add({"name": itemName, "quantity": quantity});
          }

          // Create a new map with the 'name' field instead of 'food_id' and the calculated total
          final updatedItem = {
            "_id": rd["_id"],
            "order": newOrder,
            "total": total,
            "createdAt": DateTime.parse(rd["createdAt"]),
            "updatedAt": DateTime.parse(rd["updatedAt"]),
            "__v": rd["__v"],
          };

          updatedData.add(updatedItem);
          entryTotal += total; // Add the entry total to the overall amount
        }

        setState(() {
          total = entryTotal;
          reportData = updatedData;
          print(reportData);
        });
      }
    } catch (err) {
      print('Error: $err');
    }
  }

  @override
  void initState() {
    fetchReportData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    void ascendingSort(String property) {
      setState(() {
        reportData.sort((a, b) {
          double totalA = a[property];
          double totalB = b[property];
          return totalA.compareTo(totalB);
        });
        totalAscend = !totalAscend;
      });
    }

    void descendingSort(String property) {
      setState(() {
        reportData.sort((a, b) {
          double totalA = a[property];
          double totalB = b[property];
          return totalB.compareTo(totalA);
        });
        totalAscend = !totalAscend;
      });
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: pri_color,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth / 6 - 20,
                  child: Row(
                    children: [
                      Text(
                        'Date',
                        style: navItemStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenWidth / 6 - 20,
                  child: Text(
                    'Time',
                    style: navItemStyle,
                  ),
                ),
                SizedBox(
                  width: screenWidth / 6 - 20,
                  child: Text(
                    'Operator Name',
                    style: navItemStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Order',
                    style: navItemStyle,
                  ),
                ),
                SizedBox(
                  width: screenWidth / 6 - 20,
                  child: Row(
                    children: [
                      Text(
                        'Total',
                        style: navItemStyle,
                      ),
                      IconButton(
                        onPressed: () {
                          totalAscend
                              ? descendingSort('total')
                              : ascendingSort('total');
                        },
                        icon: totalAscend
                            ? const Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.white,
                                size: 17,
                              )
                            : const Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.white,
                                size: 17,
                              ),
                        tooltip:
                            totalAscend ? 'Descending Sort' : 'Ascending Sort',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var data in reportData) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: sec_color,
                      margin: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth / 6 - 20,
                            child: Text(
                                data['createdAt'].toString().substring(0, 10)),
                          ),
                          SizedBox(
                            width: screenWidth / 6 - 20,
                            child: Text(
                                '${data['createdAt'].hour}:${data['createdAt'].minute} ${data['createdAt'].hour > 12 ? 'PM' : 'AM'}'),
                          ),
                          SizedBox(
                            width: screenWidth / 6 - 20,
                            child: const Text('Username'),
                          ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                for (var odr in data['order']) ...[
                                  Text('${odr['quantity']} x ${odr['name']}'),
                                ]
                              ])),
                          SizedBox(
                            width: screenWidth / 6 - 20,
                            child: Text('${data['total']} $currency'),
                          ),
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
          Container(
            color: sec_color,
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            padding: const EdgeInsets.all(20),
            child: Text(
              'Net Total : $total $currency',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: pri_color,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GraphView extends StatelessWidget {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Graph View'),
    );
  }
}
