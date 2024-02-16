import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:ostrinder/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calls.dart';
//let's see :)
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
                  Padding(
                    padding: isWebMobile ? EdgeInsets.all(0.0): EdgeInsets.only(right: ((MediaQuery.of(context).size.width)/2)-250, left: 0.0),
                    child:  isWebMobile  ? IconButton(onPressed: () {
                          launchUrl(Uri.parse(
                              "https://docs.google.com/spreadsheets/d/199ajAA3xPpAQeUbqYiaRYCVYL0jM3TWnfaTf8uafamM/edit?usp=sharing"));
                        }, icon: Icon(Icons.account_box_rounded)) : TextButton(
                        onPressed: () {
                          launchUrl(Uri.parse(
                              "https://docs.google.com/spreadsheets/d/199ajAA3xPpAQeUbqYiaRYCVYL0jM3TWnfaTf8uafamM/edit?usp=sharing"));
                        },
                        child: Text("לחצו כאן לזמינות המתנדבים", style: TextStyle(fontSize: 32, color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),)),
                  ),
                  IconButton(
                      onPressed: () {
                        if (supabase.auth.currentUser == null) {
                          Navigator.pushNamed(context, '/sign',
                                  arguments: "profile")
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
                          : BoringAvatars(
                              name: supabase.auth.currentUser!.email!)),
                  IconButton(
                      onPressed: () {
                        launchUrl(Uri.parse(
                            "https://github.com/forecaster-cyber/Meshik"));
                      },
                      icon: Icon(Icons.info)),
                  
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: "שיחות פרטיות",
                    ),
                    Tab(
                      text: "לוח שאלות",
                    ),
                  ],
                ),
              ),
            ))),
        body: const TabBarView(
          children: [
            calls_screen(),
            QuestionsBoard(),
          ],
        ),
      ),
    );
  }
}
