import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

bool open = false;

class calls_screen extends StatefulWidget {
  const calls_screen({super.key});

  @override
  State<calls_screen> createState() => _calls_screenState();
}

class _calls_screenState extends State<calls_screen> {
  final stream = supabase
      .from("rooms")
      .stream(primaryKey: ["room_num"]).order("room_num", ascending: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          List<Map<String, dynamic>>? datatatata = snapshot.data;

          return GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 3,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(12, (index) {
              return Center(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Image(
                          image: AssetImage('assets/images/call_icon.png')),
                      onTap: () async {
                        if (supabase.auth.currentUser?.email ==
                            "efigang@gmail.com") {
                          final data = await supabase
                              .from('rooms')
                              .select('open')
                              .eq("room_num", index);
                          print(data);
                          await supabase
                              .from('rooms')
                              .update({'open': !data[0]['open']}).match(
                                  {'room_num': index});
                        } else {
                          print("unauthirzed");
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (datatatata![index]['open']) {
                          launchUrl(Uri.parse(datatatata![index]['link']));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("החדר לא פתוח"),
                            duration: Duration(milliseconds: 300),
                          ));
                        }
                      },
                      child: Text(datatatata![index]['open'] ? "פתוח" : "סגור"),
                    )
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
