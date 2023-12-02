import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  Supabase.initialize(
    url: 'https://qnwzkrvbedkphyylkrgb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFud3prcnZiZWRrcGh5eWxrcmdiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE0MzYxNjQsImV4cCI6MjAxNzAxMjE2NH0.jtiObMhtY0dRqRLZCFkxs87vPUlF0MAUoBN-dw20A_o',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Questions App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Questions'),
      ),
      body: MathQuestionsGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddQuestionDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              height: 300,
              child: AlertDialog(
                title: Text('Add a New Question'),
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
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Upload image to Supabase
                      if (_selectedImage != null) {
                        _uploadImageToSupabaseBucket();
                      }

                      Navigator.of(context).pop();
                    },
                    child: Text('Upload Question'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
}

class MathQuestionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
