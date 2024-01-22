//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:seclogin/signin.dart';
//import 'package:seclogin/signin.dart';
import 'package:flutter/cupertino.dart';

class ForgotPassword extends StatefulWidget {
  final void Function()? onPressed2;
  const ForgotPassword({super.key, required this.onPressed2});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Future passwordReset() async {
  //   try {
  //     await FirebaseAuth.instance
  //         .sendPasswordResetEmail(email: _emailController.text.trim());
  //     // ignore: use_build_context_synchronously
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return CupertinoAlertDialog(
  //             content: const Text(
  //                 'Password Reset Link send succesfully, Check your Email!!',
  //                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
  //             actions: [
  //               MaterialButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text(
  //                   'OK',
  //                   style: TextStyle(color: Colors.blue[900]),
  //                 ),
  //               )
  //             ],
  //           );
  //         });
  //   } on FirebaseAuthException catch (e) {
  //     (e);
  //     // ignore: use_build_context_synchronously
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return const CupertinoAlertDialog(
  //             content: Text(
  //               'Enter a Valid Email Id',
  //               style: TextStyle(
  //                 fontSize: 15,
  //               ),
  //             ),
  //           );
  //         });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[50],
          leading: IconButton(
              onPressed: widget.onPressed2, icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 25,
            ),
            child: Row(children: [
              Text(
                'Reset Password',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 33,
                    fontWeight: FontWeight.w700),
              ),
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(children: [
              Text(
                """Enter the email associated with your account
and we will send an email to reset your 
password.""",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ]),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(children: [
              Text(
                'E-mail address',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ]),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Enter Email",
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue[100], //background color of button
                    //border width and color
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(8)),
                    //content padding inside button),
                  ),
                  onPressed: () {}, //passwordReset,
                  child: const Center(
                    child: const Text("Send Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black)),
                  ),
                )),
          ),
        ])));
  }
}
