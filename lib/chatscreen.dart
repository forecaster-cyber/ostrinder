import 'package:flutter/material.dart';
import 'package:ostrinder/answersscreen.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              "שאלה מספר" + " " + widget.id.toString(),
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              child: Image.network(links[ids.indexOf(widget.id)]),
              onTap: () {
                launchUrl(Uri.parse(links[ids.indexOf(widget.id)]));
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => answers(
                                answers_for_question:
                                    asnwers[ids.indexOf(widget.id)],
                                id: widget.id,
                              )));
                },
                child: Text("תשובות"))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
