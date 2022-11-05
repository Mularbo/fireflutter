import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/UI/posts/post_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationID;
  const VerifyCodeScreen({super.key, required this.verificationID});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final verifyCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veify"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: verifyCodeController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "6 digit code"),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
                loading: loading,
                title: "Verify",
                onTap: (() async {
                  setState(() {
                    loading = false;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationID,
                      smsCode: verifyCodeController.text.toString());
                  try {
                    await _auth.signInWithCredential(credential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => PostScreen())));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
                })),
          ],
        ),
      ),
    );
  }
}
