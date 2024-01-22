//import 'package:blog/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Showblog extends StatefulWidget {
  Showblog({super.key, required this.docID});

  String docID;

  @override
  State<Showblog> createState() => _ShowblogState();
}

final userid = FirebaseAuth.instance.currentUser!.uid;

class _ShowblogState extends State<Showblog> {
  void deleteComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection('Blogs')
        .doc(widget.docID)
        .collection('Comments')
        .doc(commentId)
        .delete();
  }

  void addComment(String comment) async {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    String currentTime = DateFormat('HH:mm').format(DateTime.now());
    final currentUser = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    await FirebaseFirestore.instance
        .collection('Blogs')
        .doc(widget.docID)
        .collection('Comments')
        .add({
      'date': formattedDate,
      'time': currentTime,
      'comment': comment,
      // 'likes': 0,
      // 'timestamp': FieldValue.serverTimestamp(),
      // 'userId': FirebaseAuth.instance.currentUser!.uid,
      'userName': currentUser['fname'],
      'userImage': currentUser['Url'],
      // You can add more fields like user name, user image, etc.
    });
  }

  Future<Map<String, dynamic>?> getAuthorData(String authorId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> authorDoc = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(authorId)
          .get();
      return authorDoc.data();
    } catch (error) {
      print('Error fetching author data: $error');
      return null;
    }
  }

  void likeBlogPost() async {
    await FirebaseFirestore.instance
        .collection('Blogs')
        .doc(widget.docID)
        .update({
      'likes': FieldValue.increment(1),
    });
  }

  final TextEditingController comments = TextEditingController();

  @override
  void dispose() {
    comments.dispose();
    super.dispose();
  }

  void savePost() async {
    final savedBy = await FirebaseFirestore.instance
        .collection('Blogs')
        .doc(widget.docID)
        .get()
        .then((snapshot) => snapshot.data()?['savedBy'] ?? []);

    // Check if the user has already saved the post
    if (!savedBy.contains(FirebaseAuth.instance.currentUser!.uid)) {
      // User has not saved the post
      await FirebaseFirestore.instance
          .collection('Blogs')
          .doc(widget.docID)
          .update({
        'savedBy':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });

      // You can show a message or handle this case as needed
      print('Post saved successfully.');
    } else {
      // User has already saved the post
      // You can show a message or handle this case as needed
      print('User has already saved the post.');
    }
  }

  Widget buildComments() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('Blogs')
          .doc(widget.docID)
          .collection('Comments')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              for (var doc in snapshot.data!.docs)
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(doc['userImage']),
                  ),
                  title: Text(doc['comment']),
                  subtitle: Text(
                    'By ${doc['userName']} ',
                  ),
                  trailing: Text('${doc['date']}'),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                            child: AlertDialog(
                          // title: Text("Are You Sure!!"),
                          titleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                          actionsOverflowButtonSpacing: 20,
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                            ElevatedButton(
                                onPressed: () {
                                  deleteComment(doc.id);
                                  Navigator.pop(context);
                                },
                                child: Text("Yes")),
                          ],
                          content: Text("Do you want to Delete this comment?"),
                        ));
                      },
                    );
                  },
                ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Text('No comments available.');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //   final output = snapshot.data!.data();
            // final Name = output?['fname'] ?? 'deafault Name';
            // final Url = output?['Url'] ?? 'fhghg';
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'Blog',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                backgroundColor: Colors.blue[100],
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return const HomePage();
                      // }));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
              ),
              body: SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Blogs')
                        .doc(widget.docID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final output = snapshot.data!.data();

                        final title = output!['Title'];
                        final blog = output['Blog'];
                        final date = output['date'];

                        final time = output['time'];
                        final authorId = output['authorId'];
                        // final insMail = output['Institution_Mail'];
                        final url = output['url'];
                        return FutureBuilder(
                            future: getAuthorData(authorId),
                            builder: (context, authorSnapshot) {
                              if (authorSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (authorSnapshot.hasError ||
                                  !authorSnapshot.hasData) {
                                return const Text('Unknown Author');
                              }

                              String authorName =
                                  authorSnapshot.data!['fname'] ??
                                      'Unknown Author';
                              String authorImage =
                                  authorSnapshot.data!['Url'] ?? '';
                              // Status of faculty
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          url,
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.72,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  savePost();
                                                },
                                                icon: Icon(Icons.bookmark)),
                                            IconButton(
                                              icon: Icon(Icons.star),
                                              onPressed: () {
                                                // Implement code to handle like action here
                                                likeBlogPost();
                                              },
                                            ),
                                            Text('${output['likes']}'),
                                          ],
                                        ),
                                        Text(
                                          '$title',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '$blog',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Blog by:  ',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(authorImage),
                                              radius: 14,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              authorName,
                                              style: const TextStyle(
                                                fontSize: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Text('Posted at: $date, on $time'),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                          'Add Comments:',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextFormField(
                                            controller: comments,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    addComment(
                                                        comments.text.trim());
                                                  },
                                                  icon:
                                                      const Icon(Icons.upload)),
                                              hintText: 'Add Comments here..',
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                              border:
                                                  const UnderlineInputBorder(),
                                            )),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        buildComments(),
                                      ],
                                    ),
                                  ),
                                  ///////////////////////////////////////////////////////// Buttons ///////////////////////////////
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              );
                            });
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const Center(child: Text("Connection Issuses"));
                      }
                    }),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("Connection Issuses"));
          }
        });
  }
}
