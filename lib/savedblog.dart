import 'package:blog/homepage.dart';
import 'package:blog/showblog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedPostsScreen extends StatefulWidget {
  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[100],
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          'Saved Blogs',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Blogs')
            .where('savedBy', arrayContains: currentUserID)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No saved posts.');
          } else {
            List docID = [];
            var docs = snapshot.data!.docs;
            snapshot.data!.docs.forEach((element) {
              docID.add(element.id);
              // Notification_Services().showNotification(
              //     title: "Request", body: "Student Request");
            });
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // final post = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 7,
                    width: MediaQuery.of(context).size.width / 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Showblog(
                            docID: docID[index],
                          );
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.blue[50]),
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 4,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRect(
                                child: Image.network(
                                  '${docs[index]['url']}',
                                  width: MediaQuery.of(context).size.width / 3,
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 100,
                              width: 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${docs[index]['Title']}',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${docs[index]['date']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
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
                // Build UI for each saved post
                // return ListTile(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) {
                //       return Showblog(
                //         docID: docID[index],
                //       );
                //     }));
                //   },
                //   title: Text(post['Title']),
                //   subtitle: Text(
                //     post['Blog'],
                //     maxLines: 2,
                //   ),
                //   leading: CircleAvatar(
                //     backgroundImage: NetworkImage(post['url']),
                //   ),
                //   // Add more details as needed
                // );
              },
            );
          }
        },
      ),
    );
  }
}
