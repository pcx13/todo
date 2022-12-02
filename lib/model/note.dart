import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  final String note;
  final DateTime date;

  Note({
    this.id = '',
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'note': note,
        'date': date,
      };

  static Note fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        note: json['note'],
        date: (json['date'] as Timestamp).toDate(),
      );
}
