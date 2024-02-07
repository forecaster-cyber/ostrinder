import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

bool open = false;
bool isWebMobile = kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

class calls_screen extends StatefulWidget {
  const calls_screen({super.key});

  @override
  State<calls_screen> createState() => _calls_screenState();
}

class _calls_screenState extends State<calls_screen> {
  final stream = supabase
      .from("rooms")
      .stream(primaryKey: ["room_num"]).order("open", ascending: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bruh.svg',
            alignment: Alignment.center,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              List<Map<String, dynamic>>? datatatata = snapshot.data;
              return GridView.count(
                crossAxisCount: isWebMobile ? 1 : 3,
                children: List.generate(datatatata!.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    datatatata![index]['name'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isWebMobile ? 25.0 : 50.0),
                                  ),
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
                                            .eq("name",
                                                datatatata![index]['name']);
                                        print(data);

                                        await supabase.from('rooms').update(
                                            {'open': !data[0]['open']}).match({
                                          'name': datatatata![index]['name']
                                        });
                                      } else {
                                        print("unauthorized");
                                        print(kIsWeb);
                                        print(datatatata);
                                      }
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: datatatata![index]
                                                ['open']
                                            ? Colors.green
                                            : Colors.red),
                                    onPressed: () {
                                      if (datatatata![index]['open']) {
                                        launchUrl(Uri.parse(
                                            datatatata![index]['link']));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "החדר לא פתוח",
                                          ),
                                          duration: Duration(milliseconds: 300),
                                        ));
                                      }
                                    },
                                    child: Padding(
                                      padding: isWebMobile
                                          ? const EdgeInsets.all(0.0)
                                          : const EdgeInsets.all(8.0),
                                      child: Text(
                                        datatatata![index]['open']
                                            ? "החדר זמין"
                                            : "החדר לא זמין",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isWebMobile ? 22.5 : 45),
                                      ),
                                    ),
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
