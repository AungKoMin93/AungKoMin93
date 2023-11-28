import 'package:flutter/material.dart';
import 'package:aungkomin_ap_assignment/Screens/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Config/sys_variable.dart';

// ignore: must_be_immutable
class OrdersPipeline extends StatefulWidget {
  Function(dynamic label, dynamic stage) goBackMenu;
  OrdersPipeline({Key? key, required this.goBackMenu}) : super(key: key);

  @override
  State<OrdersPipeline> createState() => _OrdersPipelineState();
}

class _OrdersPipelineState extends State<OrdersPipeline> {
  var stages;
  var processes = ['Ordered', 'Processing', 'Done', 'Served'];

  @override
  void initState() {
    getStages();
    super.initState();
  }

  void getStages() async {
    try {
      final response = await http
          .get(Uri.parse('http://$server_add:$server_port/stage/get'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          stages = jsonResponse['success'];
        });
      } else {
        throw Exception('Failed to fetch stage data');
      }
    } catch (err) {
      print('Error : $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: thi_color,
      width: screenWidth,
      height: screenHeight,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var process in processes) ...[
              SizedBox(
                width: screenWidth / (processes.length) - 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      process,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (stages != null)
                      for (var stage in stages) ...[
                        if (stage['stage'] == process)
                          StageCard(
                            stage: stage['label'],
                            orders: stage['order'],
                            currentStage: stage['stage'],
                            total: stage['total'],
                            onDelete: () => {
                              setState(() {
                                getStages();
                              })
                            },
                            onServe: () => {
                              setState(() {
                                getStages();
                              })
                            },
                            onAddOrder: () => widget.goBackMenu(
                                stage['label'], stage['stage']),
                          ),
                      ]
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class StageCard extends StatefulWidget {
  String stage;
  var orders;
  var total;
  var currentStage;
  Function onDelete;
  Function onServe;
  Function onAddOrder;
  StageCard(
      {super.key,
      required this.stage,
      required this.orders,
      required this.currentStage,
      required this.total,
      required this.onDelete,
      required this.onServe,
      required this.onAddOrder});

  @override
  State<StageCard> createState() => _StageCardState();
}

class _StageCardState extends State<StageCard> {
  Map<String, int> itemNames = {};
  bool toEdit = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      toEdit = false;
    });
    fetchItemData();
  }

  void fetchItemData() async {
    try {
      for (var order in widget.orders) {
        final regBody = {"id": order['food_id']};
        final qty = order['quantity'];

        final response = await http.post(
          Uri.parse('http://$server_add:$server_port/items/getById'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final itemName = jsonResponse['success']['name'];
          setState(() {
            itemNames[itemName] = qty;
            print(itemNames.toString());
          });
        } else {
          throw Exception('Failed to fetch stage data');
        }
      }
    } catch (err) {
      print('Error : $err');
    }
  }

  Future<void> deleteStage(id) async {
    try {
      final regBody = {"id": id};
      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/stage/close'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        print('Stage Closed');
      }
    } catch (err) {
      print('Error: $err');
    }
  }

  Future<void> moveStage(id) async {
    try {
      final regBody = {"id": id};
      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/stage/move'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        print('Stage Moved');
      }
    } catch (err) {
      print('Error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: sec_color,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.stage,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: pri_color,
                    fontSize: 25),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      toEdit ? toEdit = false : toEdit = true;
                    });
                  },
                  icon: toEdit
                      ? const Icon(
                          Icons.close_rounded,
                          color: pri_color,
                          size: 22,
                        )
                      : const Icon(
                          Icons.edit_outlined,
                          color: pri_color,
                          size: 20,
                        ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (itemNames.isNotEmpty)
            for (var item in itemNames.keys) ...[
              Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  child: Text('${itemNames[item]} x $item')),
            ],
          Container(
              height: 40,
              alignment: Alignment.centerLeft,
              child: Text('Total: ${widget.total} $currency')),
          Visibility(
              visible: toEdit,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.currentStage == 'Ordered' ||
                        widget.currentStage == 'Processing')
                      ElevatedButton(
                        onPressed: () {
                          widget.onAddOrder();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pri_color),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Additional Orders'),
                        ),
                      ),
                    if (widget.currentStage == 'Done' ||
                        widget.currentStage == 'Served')
                      OutlinedButton(
                          onPressed: () {
                            widget.onAddOrder();
                          },
                          child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Additional Orders',
                                style: TextStyle(color: pri_color),
                              ))),
                    if (widget.currentStage != 'Processing')
                      const SizedBox(
                        height: 10,
                      ),
                    if (widget.currentStage == 'Ordered') ...[
                      OutlinedButton(
                        onPressed: () async {
                          await deleteStage(widget.stage);
                          widget.onDelete();
                        },
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Cancel Order'),
                        ),
                      ),
                    ],
                    if (widget.currentStage == 'Done' ||
                        widget.currentStage == 'Served') ...[
                      ElevatedButton(
                          onPressed: () async {
                            widget.currentStage == 'Served'
                                ? await deleteStage(widget
                                    .stage) // change this to print invoice function
                                : await moveStage(widget.stage);
                            widget.onServe();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: pri_color),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: widget.currentStage == 'Done'
                                ? const Text('Serve')
                                : const Text('Check'),
                          )),
                    ],
                  ])),
        ],
      ),
    );
  }
}
