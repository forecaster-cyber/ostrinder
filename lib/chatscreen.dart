import 'package:flutter/material.dart';
import 'package:ostrinder/answersscreen.dart';
import 'main.dart';

class chat extends StatefulWidget {
  const chat({super.key, required this.id});
  final int id;

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "שאלה מספר" + " " + widget.id.toString(),
            style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          Image.network(links[ids.indexOf(widget.id)]),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => answers(answers_for_question: asnwers[ids.indexOf(widget.id)], id: widget.id,)));
              },
              child: Text("תשובות"))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
