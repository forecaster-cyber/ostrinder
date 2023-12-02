import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qnwzkrvbedkphyylkrgb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFud3prcnZiZWRrcGh5eWxrcmdiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE0MzYxNjQsImV4cCI6MjAxNzAxMjE2NH0.jtiObMhtY0dRqRLZCFkxs87vPUlF0MAUoBN-dw20A_o',
  );

  final data = await supabase.from('questions').select('*');
  runApp(const MainApp());

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
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
