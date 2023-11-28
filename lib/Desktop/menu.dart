import 'dart:convert';

import 'package:aungkomin_ap_assignment/Config/sys_variable.dart';
import 'package:aungkomin_ap_assignment/Config/TempData.dart';
import 'package:flutter/material.dart';
import 'package:aungkomin_ap_assignment/Screens/theme.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  final String tableId;
  final String currentStage;
  final bool additionalOrder;
  Menu(this.tableId, this.currentStage, this.additionalOrder, {super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<dynamic> fList = [];
  Map<dynamic, dynamic> selectedList = tempflist;
  double total = 0;
  String selectedTable = '';
  String currentStageToUpdate = '';
  bool additionOrder = false;
  final TextEditingController _idCtl = TextEditingController();

  @override
  void initState() {
    _idCtl.addListener(() {});
    setState(() {
      selectedTable = widget.tableId;
      currentStageToUpdate = widget.currentStage;
      selectedList = tempflist;
      additionOrder = widget.additionalOrder;
    });
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://$server_add:$server_port/items/get'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          fList = jsonResponse['success'];
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void sendOrder(tableIds, order) async {
    try {
      final orderList = order.entries.map((entry) {
        final item = entry.key;
        final quantity = entry.value;
        return {
          'food_id': item['id'], // Replace with the actual field name
          'quantity': quantity,
        };
      }).toList();

      var regBody = {"tableIds": tableIds, "order": orderList};

      // print(jsonEncode(regBody).toString());

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/stage/create'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse['success']);
      }

      setState(() {
        tempflist.clear();
        selectedList = tempflist;
        selectedTable = '';
        total = 0;
      });
    } catch (err) {
      print('Error : $err');
    }
  }

  void updateOrder(stageId, additionalOrder) async {
    try {
      final orderList = Map<String, dynamic>.from({});
      additionalOrder.forEach((itemId, quantity) {
        orderList[itemId['id'].toString()] = quantity;
      });

      var regBody = {"stageId": stageId, "additionalOrder": orderList};

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/stage/update'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse['success']);
      }

      setState(() {
        tempflist.clear();
        selectedList = tempflist;
        selectedTable = '';
        additionOrder = false;
        total = 0;
      });
    } catch (err) {
      print('Error: $err');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    _idCtl.value = selectedTable == ''
        ? const TextEditingValue(text: '')
        : TextEditingValue(text: widget.tableId);

    void updateTotal() {
      total = 0;
      for (var item in selectedList.keys) {
        total += item['price'] * selectedList[item];
      }
    }

    return Container(
      color: thi_color,
      width: screenWidth,
      height: screenHeight,
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenWidth * 2 / 3 - 20,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 20,
                children: [
                  for (var item in fList) ...[
                    ItemCard(
                        item,
                        (p0, quantity) => {
                              setState(() {
                                selectedList = tempflist;
                                updateTotal();
                              })
                            })
                  ]
                ],
              ),
            ),
          ),
          Container(
            width: screenWidth / 3 - 20,
            height: screenHeight,
            color: sec_color,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _idCtl,
                  decoration: const InputDecoration(hintText: 'Table ID'),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Selected Items',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var f in tempflist.keys) ...[
                          SelectedItem(
                              f,
                              tempflist[f]!,
                              (f, qty) => {
                                    setState(() {
                                      selectedList[f] = qty;
                                      tempflist = selectedList;
                                      updateTotal();
                                    })
                                  },
                              (f, qty) => {
                                    setState(() {
                                      tempflist = selectedList;
                                      updateTotal();
                                    })
                                  }),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('Total : $total $currency'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tempflist = selectedList;
                      additionOrder
                          ? currentStageToUpdate == 'Done' ||
                                  currentStageToUpdate == 'Served'
                              ? sendOrder(_idCtl.text, tempflist)
                              : updateOrder(_idCtl.text, tempflist)
                          : sendOrder(_idCtl.text, tempflist);
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: pri_color),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: additionOrder
                        ? const Text('Confirm Additional Order')
                        : const Text('Confirm Order'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final item;
  final Function(dynamic, int quantity) onAdd;
  const ItemCard(this.item, this.onAdd, {super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: sec_color,
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            'http://$server_add:$server_port/${widget.item['image']}',
            height: 100,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 220,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item['name'],
                    style: const TextStyle(fontSize: 20, color: pri_color),
                  ),
                  Text(
                    'Type : ${widget.item['type']}',
                  ),
                  Text(
                    'Price : ${widget.item['price']} $currency',
                  ),
                  if (widget.item['stock'] != null)
                    Text('Stock : ${widget.item['stock']}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity += 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pri_color),
                        icon: const Icon(Icons.add),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 0) {
                              quantity -= 1;
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pri_color),
                        icon: const Icon(Icons.remove),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (quantity > 0) {
                        if (tempflist.containsKey(widget.item)) {
                          tempflist[widget.item] =
                              (tempflist[widget.item] ?? 0) + quantity;
                        } else {
                          tempflist[widget.item] = quantity;
                        }
                        widget.onAdd(widget.item, tempflist[widget.item]!);
                      }
                      setState(() {
                        quantity = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: pri_color),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Add'),
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }
}

class SelectedItem extends StatefulWidget {
  final int qty;
  final f;
  final Function(dynamic f, int qty) onEdit;
  final Function(dynamic f, int qty) onDelete;
  const SelectedItem(this.f, this.qty, this.onEdit, this.onDelete, {super.key});

  @override
  State<SelectedItem> createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  final TextEditingController _qtyCtl = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    _qtyCtl.value = TextEditingValue(text: widget.qty.toString());

    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        color: selected_item,
        child: Column(
          children: [
            ListTile(
              leading: Text('${widget.qty} x'),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.f['name']),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 23,
                          color: pri_color,
                        ),
                        onPressed: () {
                          setState(() {
                            isVisible = true;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever_sharp,
                          size: 27,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            tempflist.remove(widget.f);
                            widget.onDelete(widget.f, widget.qty);
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Visibility(
                  visible: isVisible,
                  child: Column(
                    children: [
                      TextField(
                        controller: _qtyCtl,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                int newqty = int.parse(_qtyCtl.text);
                                tempflist[widget.f] = newqty;
                                widget.onEdit(widget.f, newqty);
                                setState(() {
                                  isVisible = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: pri_color),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text('Save'),
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: pri_color),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text('Cancel'),
                              ))
                        ],
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}
