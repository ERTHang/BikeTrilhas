
import 'package:flutter/material.dart';
import 'package:geodevmobile/login_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bike Trilhas',
      home: LoginPage(),
    );
  }
}

