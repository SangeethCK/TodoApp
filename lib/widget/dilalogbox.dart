import 'package:flutter/material.dart';

showConfirDialog(BuildContext context, String title, String content) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.red),
          ),
          child:const Text('YES'),
        ),
         ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          style:const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.green),
          ),
          child:const Text('NO'),
        ),
      ],
    ),
  );
}
