import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';

class EditNote extends StatefulWidget {
  const EditNote({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final FirestoreService firestoreService = FirestoreService();

  late final TextEditingController titleController;
  late final TextEditingController storyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    storyController = TextEditingController(text: widget.note.story);
  }

  @override
  void dispose() {
    titleController.dispose();
    storyController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (titleController.text.trim().isEmpty) return;
    if (storyController.text.trim().isEmpty) return;

    final updatedNote = Note(
      id: widget.note.id,
      title: titleController.text.trim(),
      story: storyController.text.trim(),
    );

    await firestoreService.updateNote(
      id: updatedNote.id,
      title: updatedNote.title,
      story: updatedNote.story,
    );

    if (mounted) {
      Navigator.pop(context, updatedNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              style: const TextStyle(
                fontSize: 28,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextFormField(
                controller: storyController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your story",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        child: const Icon(Icons.save),
      ),
    );
  }
}