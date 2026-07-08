import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:note_app/main.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/services/firestore_service.dart';

class FakeFirestoreService extends FirestoreService {
  FakeFirestoreService() : super.ctor();

  final List<Note> _db = [];
  final StreamController<List<Note>> _controller = StreamController<List<Note>>.broadcast();

  @override
  Future<void> addNote({
    required String title,
    required String story,
  }) async {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      story: story,
    );
    _db.add(newNote);
    _controller.add(List.from(_db));
  }

  @override
  Stream<List<Note>> getNotes() async* {
    yield List.from(_db);
    yield* _controller.stream;
  }

  @override
  Future<void> updateNote({
    required String id,
    required String title,
    required String story,
  }) async {
    final index = _db.indexWhere((n) => n.id == id);
    if (index != -1) {
      _db[index] = Note(id: id, title: title, story: story);
      _controller.add(List.from(_db));
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    _db.removeWhere((n) => n.id == id);
    _controller.add(List.from(_db));
  }
}

void main() {
  testWidgets('Create, view, and edit note smoke test', (WidgetTester tester) async {
    FirestoreService.instance = FakeFirestoreService();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is Notes App.
    expect(find.text('Notes App'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that we are on Create Note screen.
    expect(find.text('Create Note'), findsOneWidget);

    // Enter note title and story.
    await tester.enterText(find.byType(TextFormField).first, 'Test Note Title');
    await tester.enterText(find.byType(TextFormField).last, 'Test Note Story');
    await tester.pump();

    // Tap Save.
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Verify we are back on HomeScreen and note card exists.
    expect(find.text('Notes App'), findsOneWidget);
    expect(find.text('Test Note Title'), findsOneWidget);
    expect(find.text('Test Note Story'), findsOneWidget);

    // Tap on the note card to view it.
    await tester.tap(find.text('Test Note Title'));
    await tester.pumpAndSettle();

    // Verify we are on NoteView and the note details are shown.
    expect(find.text('Test Note Title'), findsOneWidget);
    expect(find.text('Test Note Story'), findsOneWidget);

    // Tap the edit button.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Verify we are on Edit Note screen.
    expect(find.text('Edit Note'), findsOneWidget);

    // Modify the note title and story.
    await tester.enterText(find.byType(TextFormField).first, 'Updated Title');
    await tester.enterText(find.byType(TextFormField).last, 'Updated Story');
    await tester.pump();

    // Tap Save.
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Verify we are back on NoteView with updated content.
    expect(find.text('Updated Title'), findsOneWidget);
    expect(find.text('Updated Story'), findsOneWidget);

    // Pop back to HomeScreen.
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Verify the updated note card is on the HomeScreen.
    expect(find.text('Notes App'), findsOneWidget);
    expect(find.text('Updated Title'), findsOneWidget);
  });
}
