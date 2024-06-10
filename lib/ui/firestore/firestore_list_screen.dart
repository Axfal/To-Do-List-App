// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/ui/auth/login_screen.dart';
// import 'package:firebase/ui/posts/add_posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../../utils/utils.dart';
import 'add_firestore_data.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  // final auth = FirebaseAuth.instance;
  final TextEditingController editingController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference reference = FirebaseFirestore.instance.collection('users');
  // or final ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firestore',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                final auth = FirebaseAuth.instance;
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final title = snapshot.data!.docs[index]['title'].toString();
                          final id = snapshot.data!.docs[index]['id'].toString();

                          return ListTile(
                            title: Text(title),
                            leading: Text(id),
                            trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert_rounded),
                              itemBuilder: (context)=> [
                                PopupMenuItem(child: ListTile(
                                  title: Text('Edit'),
                                  trailing: Icon(Icons.edit),
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(title, id);
                                  },
                                )),
                                PopupMenuItem(child: ListTile(
                                  title: Text('Delete'),
                                  trailing: Icon(Icons.delete),
                                  onTap: (){
                                    Navigator.pop(context);
                                    reference.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                  },
                                ))
                              ],
                            ),
                          );
                        }));
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFireStoreDataScreen()));
          debugPrint('ok bro111243');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editingController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: TextField(
              controller: editingController,
              decoration: InputDecoration(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    reference.doc(id).update({
                      'title' : editingController.text.toString()
                    }).then((value){
                      Utils().toastMessage('Updated Successfully');
                    }).onError((error, stackTrace){
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text('Update'))
            ],
          );
        });
  }
}
