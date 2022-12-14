import 'package:flutter/material.dart';
import 'package:moneymanager/database/db_helper.dart';
import 'package:moneymanager/pages/homepage.dart';
import 'package:lottie/lottie.dart';

class AddName extends StatefulWidget {
  AddName({Key? key}) : super(key: key);

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  DbHelper dbHelper = DbHelper();
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                child: Lottie.asset('assets/9757-welcome.json',
                fit: BoxFit.fill
                ),
              ),
              // 
                  
              Container(
                padding: EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/manager.png',
                  width: 70,
                  height: 70,
                ),
              ),
              Text(
                'please enter your name',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green[300]),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter your name', hoverColor: Colors.green[300]),
                  onChanged: (value) {
                    name = value;
                  },
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: () {
                        if (name.isNotEmpty) {
                          dbHelper.addName(name);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              action: SnackBarAction(
                                label: 'ok',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                              backgroundColor: Colors.green[300],
                              content: Text(
                                'please enter a name',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
