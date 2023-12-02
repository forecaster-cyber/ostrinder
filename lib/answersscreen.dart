import 'package:flutter/material.dart';
import 'main.dart';
import 'chatscreen.dart';

class answers extends StatefulWidget {
  const answers({super.key, required this.answers_for_question});
  final List answers_for_question;
  @override
  State<answers> createState() => _answersState();
}

class _answersState extends State<answers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder: (context, index) {
        return Image.network(widget.answers_for_question[index]);
      },itemCount: widget.answers_for_question.length,),
    );
  }
}
