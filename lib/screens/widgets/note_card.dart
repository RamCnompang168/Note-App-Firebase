import 'package:flutter/material.dart';
import '../../models/note_model.dart';
import '../../services/firestore_service.dart';
import '../edit_note.dart';

class NoteView extends StatefulWidget {
  const NoteView({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late Note currentNote;
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    currentNote = widget.note;
  }

  Future<void> _deleteNote() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: Text(
            "Are you sure you want to delete '${currentNote.title}'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await firestoreService.deleteNote(currentNote.id);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _editNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditNote(
          note: currentNote,
        ),
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentNote.title),
        actions: [
          IconButton(
            onPressed: _editNote,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _deleteNote,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          currentNote.story,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}