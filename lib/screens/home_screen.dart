import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/screens/update_note_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){

                  var doc = snapshot.data!.docs[index];

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc["title"],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.deepPurple)),
                          Divider(),
                          Text(doc["description"]),


                          // ====================
                          Row(
                            children: [
                              Spacer(),
                              InkWell(
                                onTap: (){
                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      titlePadding: EdgeInsets.only(left: 24,top: 16),
                                      title: Text("Alert !"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Divider(height: 0,),
                                          InkWell(
                                            onTap: (){
                                              Get.back();
                                              firestore.collection("notes").doc(doc.id).delete().then((value) {
                                                print("data deleted");
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Text("Delete",style: TextStyle(fontSize: 18),),
                                                Spacer(),
                                                IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              Get.back();
                                              Get.to(UpdateNoteScreen(title: doc["title"], des: doc["description"],id: doc.id,));
                                            },
                                            child: Row(
                                              children: [
                                                Text("Edit",style: TextStyle(fontSize: 18),),
                                                Spacer(),
                                                IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Icon(Icons.more_vert_rounded),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10,);
            },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNoteScreen()));
          Get.to(AddNoteScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}