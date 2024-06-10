// ignore_for_file: prefer_const_constructors

import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final verifyCodeController = TextEditingController();
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify yourself',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: verifyCodeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '6 digit code',
              ),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(
                title: 'Verify',
                loading: loading,
                onTap: ()async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(verificationId: widget.verificationId,
                      smsCode: verifyCodeController.text.toString());
                  try {
                    setState(() {
                      loading = false;
                    });
                    await _auth.signInWithCredential(credential);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
                  }
                  catch(e){
                    Utils().toastMessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
