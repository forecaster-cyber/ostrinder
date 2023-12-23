import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bruh.svg',
            alignment: Alignment.center,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              List<Map<String, dynamic>>? datatatata = snapshot.data;
              return GridView.count(
                crossAxisCount: 3,
                children: List.generate(12, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX:0, sigmaY: 0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                              child: Column(
                                children: [
                                  Text((index + 1).toString()),
                                  GestureDetector(
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/call_icon.png')),
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
                                        print("unauthorized");
                                      }
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (datatatata![index]['open']) {
                                        launchUrl(
                                            Uri.parse(datatatata![index]['link']));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("החדר לא פתוח"),
                                          duration: Duration(milliseconds: 300),
                                        ));
                                      }
                                    },
                                    child: Text(
                                        datatatata![index]['open'] ? "פתוח" : "סגור"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
