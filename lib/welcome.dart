import 'package:flutter/material.dart';
import 'main.dart';
import 'package:just_audio/just_audio.dart';

class welcome extends StatefulWidget {
  const welcome({super.key});

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("!ברוכים הבאים לאתר כפר עזרה")),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QuestionsBoard()));
              AudioPlayer player = AudioPlayer();
              await player.setAsset('assets/audios/song2.mp3');
              await player.setLoopMode(LoopMode.one);
              player.play();
            },
            child: Text("!כנסו לכפר עזרה"),
            style: ElevatedButton.styleFrom(fixedSize: Size(200, 50))),
      ),
    );
  }
}
