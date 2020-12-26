import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';
import 'Screens/addContact.dart';
import 'Screens/viewContact.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Database and Storage',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: HomePage(),
    );
  }
}
