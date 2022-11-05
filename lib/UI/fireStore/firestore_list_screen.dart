import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fireflutter/UI/auth/login_screen.dart';
import 'package:fireflutter/UI/fireStore/add_firestore_data.dart';

import 'package:fireflutter/utils/utils.dart';
import 'package:flutter/material.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final _auth = FirebaseAuth.instance;

  final editcontroller = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('Users').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Post"),
          actions: [
            IconButton(
                onPressed: () {
                  _auth
                      .signOut()
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginScreen()))))
                      .onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: Icon(Icons.logout_rounded)),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => AddFireStoreDataScreen())));
          }),
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestore,
                builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("some Error has acourd");
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            onTap: () {
                              ref
                                  .doc(snapshot.data!.docs[index]["id"]
                                      .toString())
                                  .update({'title': "muhib"}).then((value) {
                                Utils().toastMessage("post updated");
                              }).onError((error, stackTrace) {
                                Utils().toastMessage(error.toString());
                              });
                            },
                            title: Text(
                                snapshot.data!.docs[index]["title"].toString()),
                            subtitle: Text(
                                snapshot.data!.docs[index]["id"].toString()),
                          );
                        })),
                  );
                })),
          ],
        ));
  }

  Future<void> showMyDialog(String title, String id) async {
    editcontroller.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("update"),
          content: Container(
            child: TextField(
              controller: editcontroller,
              decoration: InputDecoration(
                hintText: "Edit here",
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("update")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
          ],
        );
      },
    );
  }
}
