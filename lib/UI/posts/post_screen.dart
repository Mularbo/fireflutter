import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fireflutter/UI/auth/login_screen.dart';
import 'package:fireflutter/UI/posts/add_posts.dart';
import 'package:fireflutter/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("post");
  final editcontroller = TextEditingController();
  final searchfilter = TextEditingController();
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
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddPostScreen())));
        }),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchfilter,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: ((context, snapshot, animation, index) {
                final title = snapshot.child("title").value.toString();

                if (searchfilter.text.isEmpty) {
                  return ListTile(
                    title: Text(
                      snapshot.child("title").value.toString(),
                    ),
                    subtitle: Text(snapshot.child("id").value.toString()),
                    trailing: PopupMenuButton(
                      itemBuilder: ((context) => [
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showMyDialog(title,
                                        snapshot.child('id').value.toString());
                                  },
                                  leading: Icon(Icons.edit),
                                  title: Text("edit"),
                                )),
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: () {
                                    ref
                                        .child(snapshot
                                            .child("id")
                                            .value
                                            .toString())
                                        .remove();
                                  },
                                  leading: Icon(Icons.delete),
                                  title: Text("delete"),
                                )),
                          ]),
                      icon: Icon(Icons.more_vert),
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchfilter.text.toLowerCase().toString())) {
                  return ListTile(
                    title: Text(
                      snapshot.child("title").value.toString(),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
        ],
      ),
    );
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
                  ref.child(id).update({
                    'title': editcontroller.text.toString(),
                  }).then((value) {
                    Utils().toastMessage("Post updated");
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
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
