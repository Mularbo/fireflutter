import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fireflutter/utils/utils.dart';
import 'package:fireflutter/widgets/round_button.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({super.key});

  @override
  State<AddFireStoreDataScreen> createState() => _AddFireStoreDataScreenState();
}

class _AddFireStoreDataScreenState extends State<AddFireStoreDataScreen> {
  bool loading = false;
  final firestore = FirebaseFirestore.instance.collection("Users");
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add FireStore DATA"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Whats in your mind?",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                title: "Add",
                loading: loading,
                onTap: (() {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().microsecondsSinceEpoch.toString();

                  firestore.doc(id).set({
                    "title": postController.text.toString(),
                    "id": id,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage("Post Added");
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = true;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })),
          ],
        ),
      ),
    );
  }
}
