import 'package:blog/showblog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserBlogsPage extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Blogs'),
        backgroundColor: Colors.blue[100],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Blogs')
            .where('authorId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var blogs = snapshot.data!.docs;
            List docID = [];
            var docs = snapshot.data!.docs;
            snapshot.data!.docs.forEach((element) {
              docID.add(element.id);
              // Notification_Services().showNotification(
              //     title: "Request", body: "Student Request");
            });
            return ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                //  var blog = blogs[index].data();

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
                // return ListTile(
                //   title: Text(blog['Title']),
                //   subtitle: Text(
                //     blog['Blog'],
                //     maxLines: 2,
                //   ),
                //   // Add more details as needed
                // );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('Error loading blogs'));
          }
        },
      ),
    );
  }
}
