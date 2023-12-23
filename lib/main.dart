import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ostrinder/chatscreen.dart';
import 'package:ostrinder/profilePage.dart';
import 'package:ostrinder/signScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';
import 'home_screen.dart';
import 'welcome.dart';

late dynamic data;
Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qnwzkrvbedkphyylkrgb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFud3prcnZiZWRrcGh5eWxrcmdiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE0MzYxNjQsImV4cCI6MjAxNzAxMjE2NH0.jtiObMhtY0dRqRLZCFkxs87vPUlF0MAUoBN-dw20A_o',
  );

  data = await supabase.from('questions').select('*');
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: false),
    routes: {
      // '/': (context) => welcome(),
      '/': (context) => HomeScreen(),
      '/sign': (context) {
        // You need to handle the parameters appropriately
        String redirectTo =
            ModalRoute.of(context)!.settings.arguments as String;
        return SignScreen(redirectTo: redirectTo);
      },
      '/profile': (context) => ProfilePage(),
      '/main': (context) => QuestionsBoard()
    },
    debugShowCheckedModeBanner: false,
  ));

  for (var element in data) {
    ids.add(element['id']);
    asnwers.add(element['answers']);
    links.add(element['link']);
  }
  print(data);
  print(ids);
  print(asnwers);
  print(links);
}

final supabase = Supabase.instance.client;
List ids = [];
List asnwers = [];
List links = [];

class QuestionsBoard extends StatefulWidget {
  const QuestionsBoard({super.key});

  @override
  State<QuestionsBoard> createState() => _QuestionsBoardState();
}

class _QuestionsBoardState extends State<QuestionsBoard> {
  Uint8List? _selectedImage;
  Future<void> _getImage() async {
    _selectedImage = await ImagePickerWeb.getImageAsBytes();
  }

  Future<void> _uploadImageToSupabaseBucket() async {
    final List listOfPhotos =
        await Supabase.instance.client.storage.from("questions").list();

    print(listOfPhotos);
//questions
    await Supabase.instance.client.storage.from('questions').uploadBinary(
        listOfPhotos.length.toString() + ".png", _selectedImage!,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

    await _uploadImageToSupabaseTable();
  }

  Future<void> _uploadImageToSupabaseTable() async {
    final List listOfPhotos =
        await Supabase.instance.client.storage.from("questions").list();
    final String publicUrl = Supabase.instance.client.storage
        .from('questions')
        .getPublicUrl((listOfPhotos.length - 1).toString() + ".png");
    print(listOfPhotos);
    await Supabase.instance.client.from('questions').insert({
      "id": listOfPhotos.length - 1,
      "link": publicUrl,
      "answers": [],
      "created_by": supabase.auth.currentUser!.email!
    });
  }

  @override
  void initState() {
    print('susss');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Container(
        width: 175,
        height: 50,
        child: ClipRRect(
          
          child: GestureDetector(
              onTap: () {
                if (supabase.auth.currentUser == null) {
                  Navigator.pushNamed(context, '/sign', arguments: "home")
                      .then((value) => setState(() {}));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return Container(
                            height: 300,
                            child: AlertDialog(
                              title: Text('שאל שאלה חדשה'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _selectedImage != null
                                      ? Image.memory(_selectedImage!)
                                      : TextButton(
                                          onPressed: () async {
                                            await _getImage();
                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Upload Image'),
                                              Icon(Icons.upload),
                                            ],
                                          ),
                                        ),
                                  // Add other question input fields here
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('בטל'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Upload image to Supabase
                                    if (_selectedImage != null) {
                                      _uploadImageToSupabaseBucket();
                                    }
        
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  child: Text('תוסיף את השאלה ללוח השאלות'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
                  child: Center(child: Text("יש לי שאלה", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, fontFamily: 'COMIC'),)),
                ),
              )),
        ),
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bruh.svg',
            alignment: Alignment.center,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          MasonryGridView.builder(
              itemCount: ids.length,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  // tried to make grid more responsive
                  crossAxisCount:
                      (MediaQuery.of(context).size.width ~/ 200).toInt() < 5
                          ? (MediaQuery.of(context).size.width ~/ 200).toInt()
                          : 5),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          links[index],
                          fit: BoxFit.cover,
                        )),
                    onTap: () async {
                      print(ids[index]);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => chat(id: ids[index])));
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
