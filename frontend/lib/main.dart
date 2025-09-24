import 'package:flutter/material.dart';
import 'screens/notes_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotesListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
