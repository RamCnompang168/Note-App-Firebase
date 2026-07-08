import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String story;

  Note({
    required this.id,
    required this.title,
    required this.story,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      story: data['story'] ?? data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'story': story,
    };
  }
}