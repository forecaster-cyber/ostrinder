import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:ostrinder/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calls.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 100),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AppBar(
            
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("כפר עזרה"),
          
            actions: [
              IconButton(
                  onPressed: () {
                    if (supabase.auth.currentUser == null) {
                      Navigator.pushNamed(context, '/sign', arguments: "profile")
                          .then((value) => setState(() {}));
                    } else {
                      Navigator.pushNamed(context, '/profile')
                          .then((value) => setState(() {}));
                    }
                  },
                  icon: supabase.auth.currentSession == null
                      ? CircleAvatar(
                          child: Icon(Icons.person),
                          backgroundColor: Colors.white,
                          radius: 100,
                        )
                      : BoringAvatars(name: supabase.auth.currentUser!.email!)),
              IconButton(
                  onPressed: () {
                    launchUrl(
                        Uri.parse("https://github.com/forecaster-cyber/Meshik"));
                  },
                  icon: Icon(Icons.info))
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'לוח שאלות',
                ),
                Tab(
                  text: 'שיחות פרטיות',
                ),
              ],
            ),
          ),
            ))
        ),
        body: const TabBarView(
          children: [
            QuestionsBoard(),
            calls_screen(),
          ],
        ),
      ),
    );
  }
}
