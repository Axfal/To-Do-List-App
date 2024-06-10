// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('1');

  Future getGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Image not selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Image',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              getGalleryImage();
            },
            child: Container(
              height: 100,
              width: 100,
              child: _image != null
                  ? Image.file(_image!.absolute, fit: BoxFit.cover)
                  : Icon(Icons.image),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          RoundButton(
              title: 'Upload',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/folder_name/' + DateTime.now().millisecondsSinceEpoch.toString()); // folder name & file name
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute);
                 Future.value(uploadTask).then((value) async{
                  var newUrl = await ref.getDownloadURL();
                  databaseReference.child('1').set(
                      {'id': 10, 'title': newUrl.toString()}).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Image Uploaded');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              })
        ]),
      ),
    );
  }
}
