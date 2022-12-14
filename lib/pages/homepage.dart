

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/database/db_helper.dart';
import 'package:moneymanager/model/transactions.dart';
import 'package:moneymanager/pages/add_transction.dart';
import 'package:moneymanager/widget/dilalogbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences preferences;
  late Box box;
  DbHelper dbHelper = DbHelper();
  DateTime today = DateTime.now();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataset = [];
  List<String> months = [
    'Jan',
    'Fab',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<FlSpot> getPLotPoints(List<TransactionModel> entireData) {
    dataset = [];
    List temDataSet = [];

    for (TransactionModel data in entireData) {
      if (data.date.month == today.month && data.type == 'Expense') {
        temDataSet.add(data);
      }
    }
    temDataSet.sort(
      (a, b) => a.date.day.compareTo(b.date.day),
    );
    for (var i = 0; i < temDataSet.length; i++) {
      dataset.add(
        FlSpot(
            temDataSet[i].date.day.toDouble(), temDataSet[i].amount.toDouble()),
      );
    }
    return dataset;
  }

  getTotalBalace(List<TransactionModel> entireData) {
    totalBalance = 0;
    totalExpense = 0;
    totalIncome = 0;
    // entireData.forEach((key, value) {
    //   if (value['type'] == 'Income') {
    //     totalBalance += (value['amount'] as int);
    //     totalIncome += (value['amount'] as int);
    //   } else {
    //     totalBalance -= (value['amount'] as int);
    //     totalExpense += (value['amount'] as int);
    //   }
    // });
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == 'Income') {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense += data.amount;
        }
      }
    }
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetchData() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['date'] as DateTime,
            element['note'],
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  @override
  void initState() {
    getPreference();
    super.initState();
    box = Hive.box('money');
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe2e7ef),
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[300],
          child: const Icon(
            Icons.add,
            size: 32,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => AddTransaction(),
              ),
            )
                .whenComplete(() {
              setState(() {});
            });
          }),
      body: FutureBuilder<List<TransactionModel>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Unexpeted Error'),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return  Column(
                  children: [
                    Container(
                      height: 500,
                      child: Lottie.asset('assets/31548-robot-says-hello.json'),
                    ),
                    Center(
                      child: Text('no data found , please add some data',
                      style: TextStyle(
                        color: Colors.green[300],
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                      ),
                    ),
                  ],
                );
              }
              getTotalBalace(snapshot.data!);
              // getPLotPoints(snapshot.data!);
              return ListView(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage('assets/hey.jpg'),
                                )),
                          ],
                        ),
                        Text(
                          'Welcom ${preferences.getString('name')}',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.settings,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.all(12.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.green, Colors.lightGreenAccent]),
                          borderRadius: BorderRadius.all(Radius.circular(19))),
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 8.0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            '$totalBalance',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(totalIncome.toString()),
                                cardExpense(totalExpense.toString())
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Expense',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                              spots: getPLotPoints(snapshot.data!),
                              isCurved: false,
                              barWidth: 2.5,
                              color: Colors.green[300]),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Recent Transactions',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      TransactionModel dataTIndex;
                      try {
                        dataTIndex = snapshot.data![index];
                      } catch (e) {
                        return Container();
                      }
                      if (dataTIndex.type == 'Income') {
                        return incomeTile(dataTIndex.amount, dataTIndex.note,
                            dataTIndex.date,
                            index
                            );
                      } else {
                        return expenseTile(dataTIndex.amount, dataTIndex.note,
                            dataTIndex.date, index);
                      }
                    },
                  )
                ],
              );
            } else {
              return const Center(
                child: Text('Unexpeted Error'),
              );
            }
          }),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_downward,
            size: 28,
            color: Colors.green,
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ],
        )
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_upward,
            size: 28,
            color: Colors.red,
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ],
        )
      ],
    );
  }

  Widget expenseTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool answer =
            await showConfirDialog(context, 'WARNIG', 'ARE YOU SURE !');
        if (answer != null && answer) {
          dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
            color: Color(0xffced4eb), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text('Expense'),
                  ],
                ),
                Text(
                  '${date.day} ${months[date.month - 1]}',
                  style: TextStyle(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-$value',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  note,
                  style: TextStyle(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget incomeTile(int value, String note, DateTime date, int index){
    return InkWell(
      onLongPress: () async {
        bool? answer =
            await showConfirDialog(context, 'WARNIG', 'ARE YOU SURE !');
        if (answer != null && answer) {
          dbHelper.deleteData(index);
          setState(() {});
        }
      },
     
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
            color: Color(0xffced4eb), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text('Income'),
                  ],
                ),
                Text(
                  '${date.day} ${months[date.month - 1]}',
                  style: TextStyle(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+$value',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  note,
                  style: TextStyle(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
