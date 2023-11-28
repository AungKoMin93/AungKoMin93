import 'package:aungkomin_ap_assignment/Screens/theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Config/sys_variable.dart';

class KitchenDashboard extends StatefulWidget {
  const KitchenDashboard({Key? key}) : super(key: key);

  @override
  State<KitchenDashboard> createState() => _KitchenDashboardState();
}

class _KitchenDashboardState extends State<KitchenDashboard> {
  var orderQuery;

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
          orderQuery = jsonResponse['success'];
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

    const kitchenProcesses = ['Ordered', 'Processing', 'Done'];

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
            for (var process in kitchenProcesses) ...[
              SizedBox(
                width: screenWidth / (kitchenProcesses.length) - 100,
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
                    if (orderQuery != null)
                      for (var query in orderQuery) ...[
                        if (query['stage'] == process)
                          OrderCard(
                            stage: query['label'],
                            orders: query['order'],
                            currentStage: query['stage'],
                            onAccept: () => {
                              setState(() {
                                getStages();
                              })
                            },
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
class OrderCard extends StatefulWidget {
  String stage;
  var orders;
  var currentStage;
  Function onAccept;
  OrderCard({
    super.key,
    required this.stage,
    required this.orders,
    required this.currentStage,
    required this.onAccept,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  Map<String, int> itemNames = {};

  @override
  void initState() {
    super.initState();
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

  Future<void> acceptOrder(id) async {
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.stage,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: pri_color, fontSize: 25),
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
          const SizedBox(
            height: 10,
          ),
          if (widget.currentStage != 'Done')
            ElevatedButton(
                onPressed: () async {
                  await acceptOrder(widget.stage);
                  widget.onAccept();
                },
                style: ElevatedButton.styleFrom(backgroundColor: pri_color),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widget.currentStage == 'Processing'
                      ? const Text('Done')
                      : const Text('Accept'),
                )),
        ]));
  }
}
