import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:ostrinder/main.dart';

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
        appBar: AppBar(
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
                  : BoringAvatars(name: supabase.auth.currentUser!.email!))
        ],
          bottom: const TabBar(
            tabs: [
              Tab( text: 'שיחות פרטיות',),
              Tab( text: 'לוח שאלות',),
            ],
          ),
          
        ),
        body: const TabBarView(
          children: [
            Text('שיחות פרטיות'),
            QuestionsBoard(),
            
          ],
        ),
      ),
    );
  }
}
