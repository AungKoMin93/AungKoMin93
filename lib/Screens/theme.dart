import 'package:flutter/material.dart';

const Color pri_color = Color(0xFF574B90);
const Color sec_color = Color(0xFFFFFFFF);
const Color thi_color = Color(0xB3DEDEDE);
const Color fou_color = Colors.black;
const Color form_bg_color = Color(0xFFE5E1FF);

const Color preserved_table_color = Color.fromARGB(255, 110, 108, 132);
const Color selected_item = Color(0xFFF1F1F1);

TextStyle navItemStyle = const TextStyle(color: Colors.white);
TextStyle activeStyle = const TextStyle(
    fontSize: 17, fontWeight: FontWeight.bold, color: pri_color);
TextStyle normalStyle = const TextStyle(fontSize: 17);
InputDecoration inputStyle = const InputDecoration(
    filled: true,
    fillColor: sec_color,
    contentPadding: EdgeInsets.all(10),
    border: OutlineInputBorder());

double headingSize = 25;
