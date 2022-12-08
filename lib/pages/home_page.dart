import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/auth_controller.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/widgets/note_page.dart';

class HomePage extends GetWidget<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: const Text('To Do List'),
        actions: [
          IconButton(
            onPressed: () {
              controller.signOut();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: readNote(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notes = snapshot.data!;
            return ListView(
              children: notes.map(buildNote).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => NotePage());
        },
      ),
    );
  }

  Widget buildNote(Note note) =>
      ListTile(
        title: Text(note.note),
        subtitle: Text(note.date.toString()),
        onTap: () {
          _alertDialog(note);
        },
      );

  Stream<List<Note>> readNote() =>
      FirebaseFirestore.instance
          .collection('notes')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());

  void _alertDialog(Note note) {
    showDialog(
        context: navigator!.context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: const TextStyle(
              fontSize: 16,
            ),
            titleTextStyle: const TextStyle(
              fontSize: 18,
            ),
            actionsAlignment: MainAxisAlignment.center,
            title: const Text(
              "Reminder",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: const Text("Selected note will be deleted",
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          final docUser = FirebaseFirestore.instance
                              .collection('notes')
                              .doc(note.id);
                          docUser.delete();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[200],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[200],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          );
        });
  }
}
