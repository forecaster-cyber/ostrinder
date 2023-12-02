import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ostrinder/pages/chat.dart';

List images = [
  'https://i.insider.com/5a4bdbd41cbadd4b008b456b?width=1000&format=jpeg&auto=webp',
  'https://i.insider.com/5a4bdbd41cbadd4b008b456b?width=1000&format=jpeg&auto=webp',
  'https://i.insider.com/5a4bdbd41cbadd4b008b456b?width=1000&format=jpeg&auto=webp',
  'https://i.insider.com/5a4bdbd41cbadd4b008b456b?width=1000&format=jpeg&auto=webp',
  'https://i.insider.com/5a4bdbd41cbadd4b008b456b?width=1000&format=jpeg&auto=webp',
  'https://i.insider.com/5a4bdbd41cbadd4b008b456b?width=1000&format=jpeg&auto=webp',
  'https://i.insider.com/5a4bdbd41cbadd4b008b456b?width=1000&format=jpeg&auto=webp',
];
void main() {
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
        return AlertDialog(
          title: Text('Add a New Question'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Enter your question'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the logic to add the question
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class MathQuestionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MasonryGridView.builder(
        gridDelegate:
            SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(images[index])),
            ),
          );
        },
      ),
    );
  }
}

class MathQuestionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(
          'Math Question',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
