// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/posts/add_posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController editingController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('1');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Posts',
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
          // Expanded(
          //     child: StreamBuilder(
          //   stream: ref.onValue,
          //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //     if (!snapshot.hasData) {
          //       return CircularProgressIndicator();
          //     } else {
          //       Map<dynamic, dynamic> map =
          //           snapshot.data!.snapshot.value as dynamic;
          //       List<dynamic> list = [];
          //       list.clear();
          //       list = map.values.toList();
          //       return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(list[index]['semester 01']),
          //             );
          //           });
          //     }
          //   },
          // )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('semester 01').value.toString();
                  final id = snapshot.child('id').value.toString();

                  if (searchController.text.isEmpty) {
                    return ListTile(
                      title: Text(title),
                      // subtitle: Text(id),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert_rounded),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                title: Text('Edit'),
                                trailing: Icon(Icons.edit),
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title, id);
                                },
                              )),
                          PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                title: Text('Delete'),
                                trailing: Icon(Icons.delete),
                                onTap: () {
                                  Navigator.pop(context);
                                  ref.child(id).remove();
                                },
                              ))
                        ],
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase())) {
                    return ListTile(
                      title: Text(title),
                      subtitle: Text(id),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert_rounded),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                title: Text('Edit'),
                                trailing: Icon(Icons.edit),
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title, id);
                                },
                              )),
                          PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                title: Text('Delete'),
                                trailing: Icon(Icons.delete),
                                onTap: () {
                                  Navigator.pop(context);
                                  ref.child(id).remove();
                                },
                              ))
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
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
                    ref.child(id).update({
                      'semester 01': editingController.text.toLowerCase()
                    }).then((value) {
                      Utils().toastMessage('Updated Successfully');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text('Update'))
            ],
          );
        });
  }
}
