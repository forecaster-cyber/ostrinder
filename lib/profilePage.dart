import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'chatscreen.dart';
import 'main.dart';
import 'package:flutter/material.dart';

late List userList;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    print("data: " + data.toString());
    userList = data
        .where(
          (map) => map['created_by'] == supabase.auth.currentUser!.email!,
        )
        .toList();
    print("user list: " + userList.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 75,
                      child: BoringAvatars(
                          name: supabase.auth.currentUser!.email ?? ''),
                    ),
                  ),
                  Text(supabase.auth.currentUser!.email ?? ''),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          supabase.auth.signOut();
                          Navigator.pop(context);
                        });
                      },
                      child: Row(
                        children: [Text('יציאה מהחשבון'), Icon(Icons.logout)],
                      ))
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: MasonryGridView.builder(
                  itemCount: userList.length,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      // tried to make grid more responsive
                      crossAxisCount:
                          (MediaQuery.of(context).size.width ~/ 200).toInt() < 5
                              ? (MediaQuery.of(context).size.width ~/ 200)
                                  .toInt()
                              : 5),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              userList[index]['link'],
                              fit: BoxFit.cover,
                            )),
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
          ],
        ),
      ),
    );
  }
}