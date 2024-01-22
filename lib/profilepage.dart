import 'package:blog/editprofile.dart';
import 'package:blog/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName;
  String? userImageUrl;
  int? blogCount;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBlogCount();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        userName = user.displayName;
        userImageUrl = user.photoURL;
      });
    }
  }

  Future<void> _loadBlogCount() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Blogs')
        .where('userId', isEqualTo: userid)
        .get();

    setState(() {
      blogCount = snapshot.size;
    });
  }

  int totalLikes = 0;
  Future<void> _loadTotalLikes() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Blogs')
        .where('userId', isEqualTo: userid)
        .get();

    int likes = 0;
    snapshot.docs.forEach((doc) {
      dynamic likesData = doc['likes'];

      if (likesData is int) {
        likes += likesData;
      } else if (likesData is num) {
        likes += likesData.toInt();
      }
      // Handle other cases if needed
    });

    setState(() {
      totalLikes = likes;
    });
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
            final bio = output['bio'];
            final url = output['Url'];

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(' ${fname ?? "N/A"}'),
                leading: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomePage();
                      }));
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                backgroundColor: Colors.blue[100],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(url),
                            radius: 40,
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '${blogCount ?? 0}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Posts',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '$totalLikes',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Likes',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        fname,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 100,
                        width: 150,
                        child: Container(
                          color: Colors.blue[50],
                          child: Text(
                            '$bio',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 160,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const editprofile();
                                  }));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 40,
                            width: 160,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Text(
                                  'Share Profile',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                        ],
                      )
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
