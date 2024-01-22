// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class signup extends StatefulWidget {
  final void Function()? onPressed;

  const signup({super.key, required this.onPressed});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _repasswordController = TextEditingController();
  void _submitForm() async {
    String fnameValue = _fnameController.text.trim();
    String emailValue = _emailController.text.trim();
    String passwordValue = _passwordController.text.trim();
    String repasswordValue = _repasswordController.text.trim();

    if (fnameValue.isEmpty ||
        emailValue.isEmpty ||
        passwordValue.isEmpty ||
        repasswordValue.isEmpty) {
      // Show SnackBar if the text field is blank
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          closeIconColor: Colors.white,
          showCloseIcon: true,
          backgroundColor: Colors.blue[900],
          content: const Text(
            'Please fill out all fields.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      // Handle form submission when the text field is not blank
      // You can add your logic here
      // print('Form submitted with value: $inputValue');
      await photo();
      await signIn();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'Email': _emailController.text,
        'fname': _fnameController.text,
        'Url': url,
        //'addres': _AddressController.text,
      });
    }
  }

  bool _password = true;
  //String? gender;
  File? file;
  ImagePicker image = ImagePicker();
  var url = '';
  Future signIn() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  Future photo() async {
    var imagefile = FirebaseStorage.instance
        .ref()
        .child("contact_photo")
        .child("/${_fnameController.text}.jpg");
    UploadTask task = imagefile.putFile(file!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    setState(() {
      url = url;
    });
  }

  /* void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }*/
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fnameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      // Container(
      //   constraints: const BoxConstraints.expand(),
      //   width: double.infinity,
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage("assets/P.png"),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 90),
              child: Text(
                "Create Account",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            CircleAvatar(
                backgroundColor: Colors.blue[100],
                radius: 50,
                child: CircleAvatar(
                    backgroundImage: file != null ? FileImage(file!) : null,
                    //child: file == null ? const Text('Choose Photo') : null,,
                    radius: 46,
                    child: file == null
                        ? IconButton(
                            iconSize: 40,
                            onPressed: getImage,
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.blue[500],
                            ),
                          )
                        : null)),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _fnameController,
              decoration: InputDecoration(
                  hintText: 'Enter Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: 'Enter Email-Id',
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: _password,
              controller: _passwordController,
              decoration: InputDecoration(
                  hintText: 'Enter Password',
                  suffixIcon: IconButton(
                      icon: Icon(
                          _password ? Icons.visibility_off : Icons.visibility),
                      color: Colors.grey.shade600,
                      onPressed: () {
                        setState(() {
                          _password = !_password;
                        });
                      }),
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: _password,
              controller: _repasswordController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                          _password ? Icons.visibility_off : Icons.visibility),
                      color: Colors.grey.shade600,
                      onPressed: () {
                        setState(() {
                          _password = !_password;
                        });
                      }),
                  hintText: 'Enter Confirmed Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 170),
              child: SizedBox(
                height: 60,
                width: 150,
                child: ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        foregroundColor: Colors.white,

                        //  shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            //side: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(30.0)),
                        minimumSize: const Size(100, 40)),
                    child: const Row(
                      children: [
                        Text('Sign Up',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                        SizedBox(
                          width: 7,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        )
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Text(
                    'Already Have an account ?',
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                      onPressed: widget.onPressed,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
