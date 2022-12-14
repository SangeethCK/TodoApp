import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneymanager/pages/add_name.dart';
import 'package:moneymanager/pages/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneymanager/pages/splashscreen.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox('money');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        primarySwatch: Colors.green,
      ),
      home:  SplashScreen(),
    );
  }
}

