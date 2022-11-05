import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:fireflutter/utils/utils.dart';
import 'package:fireflutter/widgets/round_button.dart';
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

  DatabaseReference databaseRef = FirebaseDatabase.instance.ref("post");

  Future getImageGallery() async {
    final PickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print("no image");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? FittedBox(
                          child: Image.file(_image!.absolute),
                        )
                      : Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RoundButton(
                loading: loading,
                title: "upload",
                onTap: (() async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      .ref("/FolderName/" +
                          DateTime.now().microsecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);

                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    databaseRef
                        .child('1')
                        .set({'id': '1212', 'title': newUrl.toString()}).then(
                            (value) {
                      Utils().toastMessage("uploded");
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  });
                })),
          ],
        ),
      ),
    );
  }
}
