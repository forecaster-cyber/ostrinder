import 'package:flutter/material.dart';
import 'main.dart';
import 'chatscreen.dart';
import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class answers extends StatefulWidget {
  const answers(
      {super.key, required this.answers_for_question, required this.id});
  final List answers_for_question;
  final int id;
  @override
  State<answers> createState() => _answersState();
}

class _answersState extends State<answers> {
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
    print(widget.answers_for_question);
    final String publicUrl = Supabase.instance.client.storage
        .from('questions')
        .getPublicUrl((listOfPhotos.length - 1).toString() + ".png");
    widget.answers_for_question.add(publicUrl);
    print(listOfPhotos);
    print(widget.answers_for_question);
    await Supabase.instance.client.from('questions').update(
        {'answers': widget.answers_for_question}).match({'id': widget.id});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("לוח תשובות"),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(fixedSize: Size(200, 50)),
          onPressed: () {
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
                          title: Text("מוזמנים להציע פתרון"),
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
                              },
                              child: Text("תוסיף את הפתרון לרשימת הפתרונות"),
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
          child: Text("יש לי פתרון"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Image.network(widget.answers_for_question[index]);
          },
          itemCount: widget.answers_for_question.length,
        ),
      ),
    );
  }
}
