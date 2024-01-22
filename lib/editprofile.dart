import 'dart:io';

import 'package:blog/profilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class editprofile extends StatefulWidget {
  const editprofile({super.key});

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  File? _image;
  final _picker = ImagePicker();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      // No image selected
      return;
    }

    try {
      final userid = FirebaseAuth.instance.currentUser!.uid;
      final ref =
          FirebaseStorage.instance.ref().child('profile_pictures/$userid.jpg');
      await ref.putFile(_image!);

      // Get the download URL
      final String downloadURL = await ref.getDownloadURL();

      // Update the user's profile picture URL in Firestore or wherever you store it
      // Example: You might have a 'Users' collection where each user has a document with a 'profilePictureURL' field.
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userid)
          .update({'Url': downloadURL});

      // Show a success message or perform any other necessary actions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile picture updated successfully!'),
      ));
    } catch (error) {
      // Handle errors
      print('Error uploading image: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update profile picture.'),
      ));
    }
  }

  Future<void> _updateFullName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userid = user.uid;

      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .update({'fname': fnameController.text});

        // Show a success message or perform any other necessary actions
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Full name updated successfully!'),
        ));
      } catch (error) {
        // Handle errors
        print('Error updating full name: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update full name.'),
        ));
      }
    }
  }

  Future<void> _updateBio() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userid = user.uid;

      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .update({'bio': bioController.text});

        // Show a success message or perform any other necessary actions
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Bio updated successfully!'),
        ));
      } catch (error) {
        // Handle errors
        print('Error updating bio: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update bio.'),
        ));
      }
    }
  }

  bool _isUploading = false;
  void _post() async {
    if (fnameController.text.isEmpty || bioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Enter all fields!'),
      ));
    } else {
      setState(() {
        _isUploading = true;
      });
      try {
        _uploadImage();
        _updateFullName();
        _updateBio();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data updated successfully!'),
        ));
      } catch (error) {
        print('Error uploading data: $error');
        // Handle errors, display a snackbar, or perform other error handling
      } finally {
        // Hide CircularProgressIndicator
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    fnameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  final userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final output = snapshot.data!.data();
            final fname = output!['fname'];
            //  final bio = output['bio'];
            final url = output['Url'];

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Profilepage();
                    }));
                  },
                  icon: Icon(Icons.close),
                ),
                title: Text('Edit Profile'),
                actions: [
                  _isUploading
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            _post();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                        ),
                ],
                backgroundColor: Colors.blue[100],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 0, top: 20),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(url),
                            radius: 40,
                            child: CircleAvatar(
                              backgroundImage:
                                  _image != null ? FileImage(_image!) : null,
                              backgroundColor: Colors.blue[100],
                              radius: 40,
                            ),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                          onTap: _pickImage,
                          child: Text(
                            'Change Profile Picture',
                            style: TextStyle(color: Colors.blue),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: fnameController,
                        decoration: InputDecoration(
                            hintText: '${fname ?? "N/A"}',
                            labelText: 'Full Name',
                            border: UnderlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: bioController,
                        maxLength: 300,
                        decoration: InputDecoration(
                            hintText: '',
                            labelText: 'Bio',
                            border: UnderlineInputBorder()),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
