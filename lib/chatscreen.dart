import 'dart:ui';

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
      floatingActionButton: Container(
          width: 175,
          height: 50,
          child: ClipRRect(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => answers(
                              answers_for_question:
                                  asnwers[ids.indexOf(widget.id)],
                              id: widget.id,
                            )));
              },
              child: BackdropFilter( filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.4),
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  child: Center(child: Text("תשובות", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, fontFamily: 'COMIC'),)),
                ),
              ),
            ),
            
          )),
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
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
