import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/UI/auth/verify_code.dart';
import 'package:fireflutter/utils/utils.dart';
import 'package:fireflutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final phoneNumController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with phone"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: "+1 234 5555 234"),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(
                title: "Login",
                loading: loading,
                onTap: (() {
                  setState(() {
                    loading = true;
                  });
                  _auth.verifyPhoneNumber(
                    phoneNumber: phoneNumController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    },
                    codeSent: (String verificationID, int? token) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => VerifyCodeScreen(
                                    verificationID: verificationID,
                                  ))));
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utils().toastMessage(e.toString());
                    },
                  );
                }))
          ],
        ),
      ),
    );
  }
}
