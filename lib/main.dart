import 'package:flutter/material.dart';
import 'package:paraleloapp1/login_module/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Example',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
