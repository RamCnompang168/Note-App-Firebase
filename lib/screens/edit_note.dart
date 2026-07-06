import 'package:flutter/material.dart';
import '../models/note_model.dart';

class EditNote extends StatefulWidget {
  const EditNote({
    super.key,
    required this.note,
    required this.onNoteSaved,
  });

  final Note note;
  final Function(Note) onNoteSaved;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                hintStyle: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: storyController,
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Your story",
                hintStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (titleController.text.trim().isEmpty) return;
          if (storyController.text.trim().isEmpty) return;

          final updatedNote = Note(
            title: titleController.text,
            story: storyController.text,
          );

          widget.onNoteSaved(updatedNote);
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
