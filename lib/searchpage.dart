// ignore_for_file: avoid_print

//import 'package:blog/homepage.dart';
import 'package:blog/showblog.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:permissionleave/SecurityGurad/pages/recentdata.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

final _security = FirebaseFirestore.instance.collection('Blogs').snapshots();

class _SearchState extends State<Search> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          elevation: 0,
          centerTitle: true,

          //automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return const HomePage();
                // }));
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: SizedBox(
            height: 50,
            width: 350,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
          // const Column(
          //   children: [
          //     Text(
          //       'All Approvals',
          //       style: TextStyle(fontSize: 25, color: Colors.white),
          //     ),
          //   ],
          // ),

          backgroundColor: Colors.blue[100],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: buildbutton(
                      title: 'Travel',
                      key: 'Travel',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: buildbutton(
                      title: 'Education',
                      key: 'Education',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: buildbutton(
                      title: 'Food',
                      key: 'Food',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: buildbutton(
                      title: 'Fashion',
                      key: 'Fashion',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: buildbutton(
                      title: 'Tech',
                      key: 'Tech',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _security,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Connection error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No data available'),
                  );
                }

                List docID = [];
                var docs = snapshot.data!.docs;

                snapshot.data!.docs.forEach((element) {
                  docID.add(element.id);
                });

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    if (buttonselected.isEmpty ||
                        data['category'].toString().toLowerCase() ==
                            buttonselected.toLowerCase()) {
                      if (name.isEmpty ||
                          data['category']
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase()) ||
                          data['Title']
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 5),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                // side: const BorderSide(
                                //   color: Colors.white,
                                // ),
                                borderRadius: BorderRadius.circular(10)),
                            tileColor: Colors.blue[50],
                            title: Text('${docs[index]['Title']}'),
                            leading: CircleAvatar(
                              backgroundImage: Image.network(
                                docs[index]['url'],
                              ).image,
                              radius: 40,
                            ),
                            subtitle: Text(
                              "${docs[index]['Blog']}",
                              maxLines: 1,
                            ),
                            contentPadding: const EdgeInsets.all(8),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Showblog(
                                  docID: docID[index],
                                );
                              }));
                            },
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                );
              },
            ),
          )
        ]));
  }

  /*FutureBuilder(
                  future: getDocId(),
                  builder: (context, snapshot) {
                    //   if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: _resultList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 2, left: 8, right: 8, bottom: 2),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor:
                                  const Color.fromARGB(255, 237, 238, 243),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(_resultList[index]['Url']),
                                radius: 30,
                              ),
                              title: Text(_resultList[index]['Name']),
                              subtitle: Text(_resultList[index]['Enrollment']),
                              trailing: Text(_resultList[index]['date']),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Showrecendata(
                                          documentId: dID[index],
                                        )));
                              },
                            ),
                          );
                        });

                    /*ListView.builder(
                        itemCount: dID.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Resdata(documentlId: dID[index]),
                            contentPadding: const EdgeInsets.all(8),
                            onTap: () {
                              print(dID[index]);
                            },
                          );
                        });*/
                    /*  } else {
                      return const Center(
                        child: Text(
                          'No data to display!!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      );
                    }*/
                  }))*/
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
            buttonselected = (buttonselected == key) ? '' : key;
          });
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          side: BorderSide(
              width: 1,
              color: buttonselected == key
                  ? Colors.blue.shade500
                  : Colors.blue.shade100),
          elevation: buttonselected == key ? 0 : 0,
          backgroundColor:
              buttonselected == key ? Colors.blue.shade500 : Colors.blue[100],
        ),
        child: Text(
          title,
          style: TextStyle(
              color: buttonselected == key ? Colors.white : Colors.black),
        ));
  }
}
