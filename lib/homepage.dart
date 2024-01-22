import 'package:blog/aboutus.dart';
import 'package:blog/addblogpage.dart';
import 'package:blog/myblogs.dart';
import 'package:blog/profilepage.dart';
import 'package:blog/savedblog.dart';
import 'package:blog/searchpage.dart';
import 'package:blog/showblog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  final _security = FirebaseFirestore.instance
      .collection('Blogs')
      .orderBy('date', descending: true)
      .snapshots();
  final userid = FirebaseAuth.instance.currentUser!.uid;
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
            final email = output['Email'];
            final url = output['Url'];

            return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text(
                    'All Blogs',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  backgroundColor: Colors.blue[100],
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Search();
                          }));
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const AddBlog();
                          }));
                        },
                        icon: const Icon(
                          Icons.add_box_outlined,
                          color: Colors.black,
                        ))
                  ],
                  leading: IconButton(
                    icon: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.closeDrawer();
                        //close drawer, if drawer is open
                      } else {
                        scaffoldKey.currentState!.openDrawer();
                        //open drawer, if drawer is closed
                      }
                    },
                  ),
                ),
                drawer: Drawer(
                  width: 280,
                  backgroundColor: Colors.blue[50],
                  elevation: 0,
                  child: ListView(padding: const EdgeInsets.all(0), children: [
                    DrawerHeader(
                        decoration: BoxDecoration(color: Colors.blue[100]),
                        child: UserAccountsDrawerHeader(
                            decoration: BoxDecoration(color: Colors.blue[100]),
                            accountName: Padding(
                              padding: const EdgeInsets.only(top: 28),
                              child: Text(
                                fname,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            accountEmail: Text(
                              email,
                              style: const TextStyle(color: Colors.black),
                            ),
                            currentAccountPictureSize: const Size.square(60),
                            currentAccountPicture: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(url),
                              ),
                            ))),
                    ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Profile'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Profilepage();
                          }));
                        }),
                    ListTile(
                        leading: const Icon(Icons.book),
                        title: const Text('My Blogs'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserBlogsPage();
                          }));
                        }),
                    ListTile(
                        leading: const Icon(Icons.bookmark),
                        title: const Text('Saved'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SavedPostsScreen();
                          }));
                        }),
                    ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('LogOut'),
                        onTap: () async {
                          setState(
                            () async {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              await logOut();
                            },
                          );
                          logOut();
                        }),
                    ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('About Us'),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return aboutus();
                        }));
                      },
                    ),
                  ]),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        'Hi! $fname',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Checkout the latest blogs.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15),
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: [
                    //         SizedBox(
                    //           height: 40,
                    //           width: 100,
                    //           child: buildbutton(
                    //             title: 'Travel',
                    //             key: 'Travel',
                    //             onPressed: () {},
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           width: 5,
                    //         ),
                    //         SizedBox(
                    //           height: 40,
                    //           width: 120,
                    //           child: buildbutton(
                    //             title: 'Education',
                    //             key: 'Education',
                    //             onPressed: () {},
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           width: 5,
                    //         ),
                    //         SizedBox(
                    //           height: 40,
                    //           width: 100,
                    //           child: buildbutton(
                    //             title: 'Food',
                    //             key: 'Food',
                    //             onPressed: () {},
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           width: 5,
                    //         ),
                    //         SizedBox(
                    //           height: 40,
                    //           width: 120,
                    //           child: buildbutton(
                    //             title: 'Fashion',
                    //             key: 'Fashion',
                    //             onPressed: () {},
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           width: 5,
                    //         ),
                    //         SizedBox(
                    //           height: 40,
                    //           width: 120,
                    //           child: buildbutton(
                    //             title: 'Tech',
                    //             key: 'Tech',
                    //             onPressed: () {},
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: _security,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('connection error');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No Blogs Available'),
                              );
                            }

                            var docs = snapshot.data!.docs;
                            List<String> docID = [];

                            snapshot.data!.docs.forEach((element) {
                              docID.add(element.id);
                            });

                            print(docID);

                            return ListView.builder(
                                itemCount: docID.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              7,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Showblog(
                                              docID: docID[index],
                                            );
                                          }));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue[50]),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRect(
                                                  child: Image.network(
                                                    '${docs[index]['url']}',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            8,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                height: 100,
                                                width: 180,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${docs[index]['Title']}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      '${docs[index]['date']}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),
                  ],
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  String buttonselected = '';
  ElevatedButton buildbutton({
    required String title,
    required String key,
    required Function onPressed,
  }) {
    return ElevatedButton(
        key: Key(key),
        onPressed: () {
          setState(() {
            if (buttonselected.isNotEmpty) {
              buttonselected = '';
            }
            buttonselected = key;
          });
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          side: BorderSide(
              width: 1,
              color: buttonselected == key ? Colors.grey : Colors.black),
          elevation: buttonselected == key ? 0 : 0,
          backgroundColor: buttonselected == key ? Colors.grey : Colors.white,
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.black),
        ));
  }
}
