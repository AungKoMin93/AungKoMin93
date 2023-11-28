import 'dart:convert';

import 'package:http/http.dart' as http;

List? list;

Future<void> fetch() async {
  var response = await http.get(Uri.parse('http://localhost:2220/items/get'));

  var jsonResponse = jsonDecode(response.body);

  list = jsonResponse['success'];
}

void main() async {
  await fetch();
  print(list![0]['price']);
}
