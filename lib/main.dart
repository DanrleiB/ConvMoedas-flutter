import 'package:convmoedas/home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json&key=6f301fec");

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const Conversor(),
        theme: ThemeData(
          primaryColor: Colors.black,
        ));
  }
}

Future<Map> getData() async {
  var response = await http.get(request);
  print(response.body);
  return json.decode(response.body);
}
