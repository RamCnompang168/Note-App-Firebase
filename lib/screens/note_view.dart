import 'package:flutter/material.dart';
import '../models/note_model.dart';
import 'edit_note.dart';

class NoteView extends StatefulWidget {
  const NoteView({
    super.key,
    required this.note,
    required this.index,
    required this.onNoteDeleted,
    required this.onNoteEdited,
  });

  final Note note;
  final int index;
  final Function(int) onNoteDeleted;
  final Function(Note, int) onNoteEdited;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late Note currentNote;

  @override
  void initState() {
    super.initState();
    currentNote = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentNote.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditNote(
                  note: currentNote,
                  onNoteSaved: (updatedNote) {
                    setState(() {
                      currentNote = updatedNote;
                    });
                    widget.onNoteEdited(updatedNote, widget.index);
                  },
                ),
              ));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Note"),
                  content: Text("Are you sure you want to delete ${currentNote.title}?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onNoteDeleted(widget.index);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              currentNote.story,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

