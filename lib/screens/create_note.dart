  import 'package:flutter/material.dart';

  import '../models/note_model.dart';



  class CreateNote extends StatefulWidget {
    const CreateNote({super.key, required this.onNoteCreated});

    final Function(Note) onNoteCreated;

    @override
    State<CreateNote> createState() => _CreateNoteState();
  }


class _CreateNoteState extends State<CreateNote> {
  late final TextEditingController titleController;
  late final TextEditingController storyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    storyController = TextEditingController();
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
          title: const Text("Create Note"),

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

            const SizedBox(height: 10,),

            TextFormField(
              controller: storyController,
              // maxLines: 999,
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
            ),
           ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (titleController.text.isEmpty) return;
            if (storyController.text.isEmpty) return;

            final note = Note(
              title: titleController.text,
              story: storyController.text,
            );

            widget.onNoteCreated(note);
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.save),
        ),
      );
    }
  }
