import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateNoteScreen extends StatefulWidget {
  final String title;
  final String des;
  final dynamic id;
  UpdateNoteScreen({super.key, required this.title, required this.des,required this.id});

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {

  final titleController = TextEditingController();
  final desController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    titleController.text = widget.title;
    desController.text = widget.des;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Note"),
        actions: [
          ElevatedButton(onPressed: (){
            firestore.collection("notes").doc(widget.id).update({
              "title":titleController.text,
              "description":desController.text,
            })
                .then((value) {
              print("data updated");
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
