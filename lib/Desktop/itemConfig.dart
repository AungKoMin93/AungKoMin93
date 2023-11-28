import 'dart:convert';
import 'dart:io';
import 'package:aungkomin_ap_assignment/Config/sys_variable.dart';
import 'package:aungkomin_ap_assignment/Screens/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ItemConfig extends StatefulWidget {
  Function onChange;
  ItemConfig({Key? key, required this.onChange}) : super(key: key);

  @override
  State<ItemConfig> createState() => _ItemConfigState();
}

class _ItemConfigState extends State<ItemConfig> {
  var flist = [];
  bool isVisible = false;
  var selectedItem;
  File? _imageFile;
  String? fileName;

  TextEditingController _newItemName = TextEditingController();
  TextEditingController _newItemType = TextEditingController();
  TextEditingController _newItemPrice = TextEditingController();
  TextEditingController _newItemStock = TextEditingController();

  TextEditingController _ItemPrice = TextEditingController();
  TextEditingController _ItemStock = TextEditingController();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://$server_add:$server_port/items/get'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          flist = jsonResponse['success'];
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void addData(String name, String type, String image, double price,
      dynamic stock) async {
    try {
      var regBody = {
        "name": name,
        "type": type,
        "image": image,
        "price": price,
        "stock": stock
      };

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/items/add'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        _newItemType.clear();
        _newItemName.clear();
        _newItemPrice.clear();
        _newItemStock.clear();
        fetchData();
        widget.onChange();
      } else {
        print("SomeThing Went Wrong");
      }
    } catch (err) {
      print('Error: $err');
    }
  }

  void updateData(
      int id, String name, String type, dynamic price, dynamic stock) async {
    try {
      var regBody = {
        "id": id,
        "name": name,
        "type": type,
        "price": price,
        "stock": stock
      };

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/items/update'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse['success']);
        fetchData();
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void deleteData(int id) async {
    try {
      var regBody = {"id": id};

      final response = await http.post(
          Uri.parse('http://$server_add:$server_port/items/delete'),
          headers: {"Content-Type": 'application/json'},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse['success']);
        fetchData();
        widget.onChange();
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        fileName = pickedFile.name.split('.').first;
      });
    }
  }

  void _submit() async {
    if (_imageFile != null) {
      final url = Uri.parse('http://192.168.100.33:2220/items/uploadImg');
      final request = http.MultipartRequest('POST', url)
        ..files
            .add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Item Configuration',
          style: TextStyle(fontSize: headingSize),
        ),
        SizedBox(
          width: 500,
          child: Visibility(
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
                  Wrap(
                    spacing: 20,
                    children: [
                      const SizedBox(
                        width: 100,
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Item name'),
                                  ],
                                )),
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Item type'),
                                  ],
                                )),
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Item price'),
                                  ],
                                )),
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Item stock'),
                                  ],
                                )),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _newItemName,
                                cursorHeight: 20,
                                decoration: inputStyle,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _newItemType,
                                cursorHeight: 20,
                                decoration: inputStyle,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _newItemPrice,
                                cursorHeight: 20,
                                decoration: inputStyle,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _newItemStock,
                                cursorHeight: 20,
                                decoration: inputStyle,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: OutlinedButton(
                                onPressed: _pickImage,
                                child: const Text(
                                  'Upload Image',
                                  style: TextStyle(color: pri_color),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 10,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  addData(
                                      _newItemName.text,
                                      _newItemType.text,
                                      fileName!,
                                      double.parse(_newItemPrice.text),
                                      _newItemStock.text);
                                  _submit();
                                  _newItemName.clear();
                                  _newItemPrice.clear();
                                  _newItemType.clear();
                                  _newItemStock.clear();
                                });
                                showBottomNotification(
                                    context, 'New item is added');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: pri_color),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Save'),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                _newItemName.clear();
                                _newItemPrice.clear();
                                _newItemType.clear();
                                _newItemStock.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: pri_color),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Cancel'),
                              )),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            child: Container(
              width: 500,
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
                  Wrap(
                    spacing: 20,
                    children: [
                      const SizedBox(
                        width: 100,
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Item name'),
                                  ],
                                )),
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Item type'),
                                  ],
                                )),
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Item price'),
                                  ],
                                )),
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Item stock'),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(selectedItem == null
                                        ? ''
                                        : selectedItem['name']),
                                  ],
                                )),
                            SizedBox(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(selectedItem == null
                                        ? ''
                                        : selectedItem['type']),
                                  ],
                                )),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _ItemPrice,
                                cursorHeight: 20,
                                decoration: inputStyle,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _ItemStock,
                                cursorHeight: 20,
                                decoration: inputStyle,
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
                                updateData(
                                    selectedItem['id'],
                                    selectedItem['name'],
                                    selectedItem['type'],
                                    _ItemPrice.text,
                                    _ItemStock.text);
                                _ItemPrice.clear();
                                _ItemStock.clear();
                                fetchData();
                                showBottomNotification(
                                    context, 'Item information is updated');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: pri_color),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Save'),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = false;
                                });
                                _ItemPrice.clear();
                                _ItemStock.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: pri_color),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Cancel'),
                              )),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        ItemTableView(
            flist,
            (fd) => {
                  setState(() {
                    selectedItem = fd;
                    isVisible = true;
                  })
                },
            (fd) => {
                  setState(() {
                    selectedItem = fd;
                    deleteData(selectedItem['id']);
                    showBottomNotification(context, 'Item is deleted');
                  })
                }),
      ],
    );
  }
}

// ignore: must_be_immutable
class ItemTableView extends StatelessWidget {
  var foodList;
  final Function(dynamic fd) onEdit;
  final Function(dynamic fd) onDelete;
  ItemTableView(this.foodList, this.onEdit, this.onDelete);

  @override
  Widget build(BuildContext context) {
    List<TableRow> generateTableRow(var foods) {
      List<TableRow> rows = [];
      rows.add(
        const TableRow(children: [
          SizedBox(height: 40, child: Center(child: Text("Name"))),
          SizedBox(height: 40, child: Center(child: Text("Type"))),
          SizedBox(height: 40, child: Center(child: Text("Price"))),
          SizedBox(height: 40, child: Center(child: Text("Stock"))),
          SizedBox(
            height: 40,
            child: Center(
              child: Text('Edit / Delete'),
            ),
          ),
        ]),
      );
      for (int j = 0; j < foods.length; j++) {
        rows.add(TableRow(children: [
          SizedBox(height: 40, child: Center(child: Text(foods[j]['name']))),
          SizedBox(height: 40, child: Center(child: Text(foods[j]['type']))),
          SizedBox(
              height: 40,
              child: Center(child: Text('${foods[j]['price']} $currency'))),
          SizedBox(
              height: 40, child: Center(child: Text('${foods[j]['stock']}'))),
          SizedBox(
            height: 40,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      onEdit(foods[j]);
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: pri_color,
                    )),
                IconButton(
                    onPressed: () {
                      onDelete(foods[j]);
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
      children: generateTableRow(foodList),
    );
  }
}
