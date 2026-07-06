
import 'package:flutter/material.dart';
import 'package:note_app/screens/widgets/note_card.dart';
import '../models/note_model.dart';
import 'create_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Note> notes = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index){
          return NoteCard(
            note: notes[index],
            index: index,
            onNoteDeleted: onNoteDeleted,
            onNoteEdited: onNoteEdited,
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CreateNote(onNoteCreated: onNewNoteCreated,)));
        },
        child: const Icon(Icons.add),
      )
    );
  }


  void onNewNoteCreated(Note note){
    notes.add(note);
    setState(() {});
  }

  void onNoteSelected(Note note) {

  }

  void onNoteDeleted(int Index) {
      notes.removeAt(Index);
      setState(() {});
  }

  void onNoteEdited(Note note, int index) {
    notes[index] = note;
    setState(() {});
  }
}
