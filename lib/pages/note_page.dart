import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/auth_controller.dart';
import 'package:todo_app/model/note.dart';

class NotePage extends GetWidget<AuthController> {
  NotePage({Key? key}) : super(key: key);

  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              final note = Note(
                note: noteController.text,
                date: DateTime.now(),
              );

              createNote(note);
              Get.back();
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          TextField(
            controller: noteController,
            autofocus: true,
            maxLength: 50,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Content',
              hintStyle: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future createNote(Note note) async {
    final docUser = FirebaseFirestore.instance.collection('notes').doc();
    note.id = docUser.id;

    final json = note.toJson();
    await docUser.set(json);
  }
}
