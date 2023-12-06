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
      appBar: AppBar(title: Text("אתר שיעורי הבית של אפי והחברים")),
      body: Center(
        child: ElevatedButton(
            onPressed: () async{
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainApp()));
                  AudioPlayer player = AudioPlayer();
    await player.setAsset('assets/audios/song2.mp3');
    player.play();
            },
            child: Text("כנס לעולם שיעורי הבית"), style: ElevatedButton.styleFrom(fixedSize: Size(200, 50))),
            
      ),
    );
  }
}
