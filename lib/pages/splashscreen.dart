

import 'package:flutter/material.dart';
import 'package:moneymanager/database/db_helper.dart';
import 'package:moneymanager/pages/add_name.dart';
import 'package:moneymanager/pages/homepage.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DbHelper dbHelper = DbHelper();
  Future getSettings() async {
    String? name = await dbHelper.getName();
    if (name != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AddName(),
        ),
      );
    }
  }
  @override
  void initState() {
    getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   padding: EdgeInsets.all(16.0),
            //   child: Image.asset(
            //     'assets/manager.png',
            //     width: 150,
            //     height: 150,
            //   ),
            // ),
            Text(
              'Money Manager',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green[300]),
            )
          ],
        ),
      ),
    );
  }
}
