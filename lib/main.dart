import 'package:flutter/material.dart';
import 'package:ostrinder/chatscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';
Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qnwzkrvbedkphyylkrgb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFud3prcnZiZWRrcGh5eWxrcmdiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE0MzYxNjQsImV4cCI6MjAxNzAxMjE2NH0.jtiObMhtY0dRqRLZCFkxs87vPUlF0MAUoBN-dw20A_o',
  );

  final data = await supabase.from('questions').select('*');
  runApp( MaterialApp(home: MainApp(),));

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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
    await Supabase.instance.client
        .from('questions')
        .insert({"id": listOfPhotos.length - 1, "link": publicUrl, "answers": []});
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: TextButton(
          child: Text("יש לי שאלה"),
          onPressed: () {
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
          },
        ),
        body: MasonryGridView.builder(
            itemCount: ids.length,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  child: Image.network(links[index]),
                  onTap: () {
                    print(ids[index]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => chat(id: ids[index])));
                  },
                ),
              );
            }),
      ),
    );
  }
}
