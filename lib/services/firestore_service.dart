import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../models/note_model.dart';

class FirestoreService {
  static FirestoreService _instance = FirestoreService.ctor();

  factory FirestoreService() => _instance;

  @protected
  FirestoreService.ctor();

  static set instance(FirestoreService service) => _instance = service;

  CollectionReference get notes =>
      FirebaseFirestore.instance.collection('notes');

  Future<void> addNote({
    required String title,
    required String story,
  }) async {
    await notes.add({
      'title': title,
      'story': story,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Note>> getNotes() {
    return notes.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};

        return Note(
          id: doc.id,
          title: data['title'] ?? '',
          story: data['story'] ?? data['description'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String story,
  }) async {
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(id)
        .update({
      'title': title,
      'story': story,
    });
  }
  Future<void> deleteNote(String id) async {
    await notes.doc(id).delete();
  }
}