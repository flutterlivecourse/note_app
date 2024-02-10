import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({super.key});

  final titleController = TextEditingController();
  final desController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Note"),
        actions: [
          ElevatedButton(onPressed: (){
            firestore.collection("notes").add({
              "title":titleController.text,
              "description":desController.text,
            })
                .then((value) {
              print("data added");
              titleController.clear();
              desController.clear();
            })
                .catchError((error) => print("Failed to add user: $error"));
          }, child: const Text("Save")),
          const SizedBox(width: 10,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.deepPurple),
              maxLines: null,
              decoration: const InputDecoration(
                labelText: "title",
                  contentPadding: EdgeInsets.all(16)
              ),
            ),
            TextField(
              controller: desController,
              maxLines: 1500,
              decoration: const InputDecoration(
                  labelText: "description",
                contentPadding: EdgeInsets.all(16)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
