import 'package:flutter/material.dart';
import 'package:sqlite/note.dart';
import 'package:sqlite/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Note App',
      home: NoteList(),
    );
  }
}
