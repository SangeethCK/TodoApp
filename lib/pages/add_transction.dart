import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneymanager/database/db_helper.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int? amount;
  String note = ' Some Expense';
  String type = 'Income';
  DateTime selectedDate = DateTime.now();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021, 12),
      lastDate: DateTime(2100, 01),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xffe2e7ef),
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Add Transactions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.attach_money),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: '0', border: InputBorder.none),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                  onChanged: (value) {
                    try {
                      amount = int.parse(value);
                    } catch (e) {
                      print(e);
                    }
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.all(12),
                child: Icon(Icons.description),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'note on transaction',
                      border: InputBorder.none),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  onChanged: (value) {
                    note = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.all(12),
                child: Icon(Icons.moving_sharp),
              ),
              SizedBox(
                width: 12,
              ),
              ChoiceChip(
                label: Text(
                  'Income',
                  style: TextStyle(
                    fontSize: 14,
                    color: type == 'Income' ? Colors.white : Colors.black,
                  ),
                ),
                selected: type == 'Income' ? true : false,
                selectedColor: Colors.green[300],
                onSelected: (value) {
                  if (value) {
                    setState(() {
                      print('2');
                      type = 'Income';
                    });
                  }
                },
              ),
              SizedBox(
                width: 12,
              ),
              ChoiceChip(
                label: Text(
                  'Expense',
                  style: TextStyle(
                    fontSize: 14,
                    color: type == 'Expense' ? Colors.white : Colors.black,
                  ),
                ),
                selected: type == 'Expense' ? true : false,
                selectedColor: Colors.green[300],
                onSelected: (value) {
                  if (value) {
                    setState(() {
                      print('1');
                      type = 'Expense';
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                _selectDate(context);
              },
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    '${selectedDate.day} ${months[selectedDate.month - 1]}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: ()async {
                if (amount != null && note.isNotEmpty) {
                  DbHelper dbHelper = DbHelper();
                 await dbHelper.addData(amount!, note, type, selectedDate);
                 Navigator.of(context).pop();
                }
              },
              child: Text(
                'Add',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
