  import 'package:flutter/material.dart';
  import '../services/firestore_service.dart';
  import '../services/firestore_service.dart';



  class CreateNote extends StatefulWidget {
    const CreateNote({super.key});

    // final Function(Note) onNoteCreated;

    @override
    State<CreateNote> createState() => _CreateNoteState();
  }


class _CreateNoteState extends State<CreateNote> {
  late final TextEditingController titleController;
  late final TextEditingController storyController;
  final FirestoreService firestoreService = FirestoreService();

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
          onPressed: () async {
            if (titleController.text.isEmpty) return;
            if (storyController.text.isEmpty) return;

            await firestoreService.addNote(
              title: titleController.text,
              story: storyController.text,
            );

            Navigator.pop(context);
          },
          child: const Icon(Icons.save),
        ),
      );
    }
  }
