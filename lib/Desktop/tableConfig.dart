import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aungkomin_ap_assignment/Config/sys_variable.dart';
import 'package:flutter/material.dart';

import '../Screens/theme.dart';

class TableConfig extends StatefulWidget {
  TableConfig({Key? key}) : super(key: key);

  @override
  State<TableConfig> createState() => _TableConfigState();
}

class _TableConfigState extends State<TableConfig> {
  final TextEditingController _tableIdCtl = TextEditingController();
  final TextEditingController _seatCountCtrl = TextEditingController();
  final TextEditingController _tableTypeCtrl = TextEditingController();

  final TextEditingController _newTableIdCtl = TextEditingController();
  final TextEditingController _newSeatCountCtrl = TextEditingController();
  final TextEditingController _newTableTypeCtrl = TextEditingController();

  var selectedTable;
  var tableList;
  bool isVisible = false;

  @override
  void initState() {
    fetchData();
    setState(() {
      isVisible = false;
    });
    super.initState();
  }

  void fetchData() async {
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

  void addData(String id, int seats, String type) async {
    var regBody = {"id": id, "seats": seats, "type": type, "taken": false};

    final response = await http.post(
        Uri.parse('http://$server_add:$server_port/tables/add'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse['status']);

    if (jsonResponse['status']) {
      _newTableTypeCtrl.clear();
      _newSeatCountCtrl.clear();
      _newTableIdCtl.clear();
      fetchData();
    } else {
      print("SomeThing Went Wrong");
    }
  }

  void updateData(String id, int seats, String type, bool taken) async {
    try {
      var regBody = {"id": id, "seats": seats, "type": type, "taken": taken};

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/tables/update'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        fetchData();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void deleteData(String id) async {
    try {
      var regBody = {"id": id};

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/tables/delete'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        fetchData();
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    _tableIdCtl.value = selectedTable == null
        ? const TextEditingValue(text: '')
        : TextEditingValue(text: selectedTable!['id']);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void showBottomNotification(context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width:
              screenWidth > screenHeight ? screenWidth / 3 : screenWidth - 40,
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: form_bg_color,
          behavior: SnackBarBehavior
              .floating, // Makes the snack bar float from the bottom.
          duration:
              const Duration(seconds: 2), // Adjust the duration as needed.
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tables Configuration',
          style: TextStyle(fontSize: headingSize),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: isVisible,
              replacement: Container(
                width: 500,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 20),
                color: form_bg_color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add new information',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 20,
                        children: [
                          const SizedBox(
                            width: 100,
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    height: 40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('ID'),
                                      ],
                                    )),
                                SizedBox(
                                    height: 40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Seats'),
                                      ],
                                    )),
                                SizedBox(
                                    height: 40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Type'),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: _newTableIdCtl,
                                    cursorHeight: 20,
                                    decoration: inputStyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: _newSeatCountCtrl,
                                    cursorHeight: 20,
                                    decoration: inputStyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: _newTableTypeCtrl,
                                    cursorHeight: 20,
                                    decoration: inputStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              addData(
                                  _newTableIdCtl.text,
                                  int.parse(_newSeatCountCtrl.text),
                                  _newTableTypeCtrl.text);
                              showBottomNotification(
                                  context, 'New table is added');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: pri_color),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Save'),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              _newSeatCountCtrl.clear();
                              _newTableIdCtl.clear();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: pri_color),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Cancel'),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 20),
                color: form_bg_color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit information',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 20,
                        children: [
                          const SizedBox(
                            width: 100,
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    height: 40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('ID'),
                                      ],
                                    )),
                                SizedBox(
                                    height: 40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Seats'),
                                      ],
                                    )),
                                SizedBox(
                                    height: 40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Type'),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          selectedTable == null
                                              ? ''
                                              : selectedTable['id'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: _seatCountCtrl,
                                    cursorHeight: 20,
                                    decoration: inputStyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: _tableTypeCtrl,
                                    cursorHeight: 20,
                                    decoration: inputStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                updateData(
                                    selectedTable['id'],
                                    int.parse(_seatCountCtrl.text),
                                    _tableTypeCtrl.text,
                                    selectedTable['taken']);
                                fetchData();
                                _tableTypeCtrl.clear();
                                _seatCountCtrl.clear();
                              });
                              showBottomNotification(
                                  context, 'Table information is updated');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: pri_color),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Save'),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              _seatCountCtrl.clear();
                              _tableIdCtl.clear();
                              setState(() {
                                isVisible = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: pri_color),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Cancel'),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        tableList == null
            ? const Center(child: CircularProgressIndicator())
            : TableView(
                tableList,
                (table) => {
                      setState(() {
                        selectedTable = table;
                        isVisible = true;
                      })
                    },
                (table) => {
                      setState(() {
                        deleteData(table['id']);
                        showBottomNotification(context, 'Table is deleted');
                      })
                    }),
      ],
    );
  }
}

// ignore: must_be_immutable
class TableView extends StatelessWidget {
  var tableList;
  final Function(dynamic table) onEdit;
  final Function(dynamic table) onDelete;
  TableView(this.tableList, this.onEdit, this.onDelete);

  @override
  Widget build(BuildContext context) {
    List<TableRow> generateTableRow(List<dynamic> tables) {
      List<TableRow> rows = [];
      rows.add(
        const TableRow(children: [
          SizedBox(height: 40, child: Center(child: Text("ID"))),
          SizedBox(height: 40, child: Center(child: Text("Seat count"))),
          SizedBox(height: 40, child: Center(child: Text("Type"))),
          SizedBox(height: 40, child: Center(child: Text("Status"))),
          SizedBox(
            height: 40,
            child: Center(
              child: Text('Edit / Delete'),
            ),
          ),
        ]),
      );
      for (int j = 0; j < tables.length; j++) {
        rows.add(TableRow(children: [
          SizedBox(height: 40, child: Center(child: Text(tables[j]['id']))),
          SizedBox(
              height: 40, child: Center(child: Text('${tables[j]['seats']}'))),
          SizedBox(
              height: 40, child: Center(child: Text('${tables[j]['type']}'))),
          SizedBox(
              height: 40,
              child: Center(
                  child: Text(tables[j]['taken'] ? 'Taken' : 'Available'))),
          SizedBox(
            height: 40,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      onEdit(tables[j]);
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: pri_color,
                    )),
                IconButton(
                    onPressed: () {
                      onDelete(tables[j]);
                    },
                    icon: const Icon(
                      Icons.delete_forever_sharp,
                      color: Colors.red,
                    ))
              ],
            ),
          )
        ]));
      }
      return rows;
    }

    return Table(
      border: TableBorder.all(width: 1),
      children: generateTableRow(tableList),
    );
  }
}
