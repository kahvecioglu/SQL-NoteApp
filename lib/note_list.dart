import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper? dbHelper;
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    loadNotes();
  }

  Future<void> loadNotes() async {
    List<Note> loadedNotes = await dbHelper!.getNotes();
    setState(() {
      notes = loadedNotes;
    });
  }

  Future<void> addNewNote() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    BuildContext dialogContext;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;

        return AlertDialog(
          title: Text('Add New Note'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Note newNote = Note(
                  title: titleController.text,
                  content: contentController.text,
                );
                await dbHelper!.AddNote(newNote);
                await loadNotes();

                Navigator.pop(dialogContext);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editNote(Note note) async {
    TextEditingController titleController =
        TextEditingController(text: note.title);
    TextEditingController contentController =
        TextEditingController(text: note.content);

    BuildContext dialogContext;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;

        return AlertDialog(
          title: Text('Edit Note'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Note updatedNote = Note(
                  id: note.id,
                  title: titleController.text,
                  content: contentController.text,
                );
                await dbHelper!.updateNote(updatedNote);
                await loadNotes();

                Navigator.pop(dialogContext);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteNoteAndReload(int id) async {
    await dbHelper!.deleteNote(id);
    await loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note List'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text(notes[index].content),
            onTap: () {
              editNote(notes[index]);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteNoteAndReload(notes[index].id!);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewNote();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
