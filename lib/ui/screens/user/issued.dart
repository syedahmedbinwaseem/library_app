import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/user/localUser.dart';
import 'package:library_app/utils/colors.dart';

class Issued extends StatefulWidget {
  @override
  _IssuedState createState() => _IssuedState();
}

class _IssuedState extends State<Issued> {
  TextEditingController searchItems = TextEditingController();
  String keyword = '';

  @override
  void initState() {
    super.initState();
    searchItems.addListener(() {
      setState(() {
        keyword = searchItems.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: navyBlue,
        appBar: AppBar(
          title: Text(
            'Issued Books',
            style: TextStyle(
              fontFamily: 'Sofia',
              color: Colors.white,
            ),
          ),
          backgroundColor: navyBlue,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('books')
                      .where('issued', isEqualTo: LocalUser.userData.email)
                      .orderBy('added_on', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return !snapshot.hasData
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(navyBlue),
                              ),
                            ),
                          )
                        : snapshot.data.docs.isEmpty
                            ? Container(
                                child: Center(
                                  child: Text(
                                    'No Books Issued',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                      fontFamily: 'Sofia',
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.data.docs[index]['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(keyword.toLowerCase()) ||
                                      snapshot.data.docs[index]['author']
                                          .toString()
                                          .toLowerCase()
                                          .contains(keyword.toLowerCase()))
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        // height:
                                        //     MediaQuery.of(context).size.height *
                                        //         0.15,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        decoration: BoxDecoration(
                                          color: pink,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                snapshot.data.docs[index]
                                                    ['name'],
                                                style: TextStyle(
                                                    fontFamily: 'Sofia',
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'By ' +
                                                    snapshot.data.docs[index]
                                                        ['author'],
                                                style: TextStyle(
                                                    fontFamily: 'Sofia',
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(height: 10),
                                              Center(
                                                child: Text(
                                                  'Issued On:\t' +
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['issued_on']
                                                          .toDate()
                                                          .day
                                                          .toString() +
                                                      '-' +
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['issued_on']
                                                          .toDate()
                                                          .month
                                                          .toString() +
                                                      '-' +
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['issued_on']
                                                          .toDate()
                                                          .year
                                                          .toString(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontFamily: 'Sofia',
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  'Return On:\t' +
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['return_on']
                                                          .toDate()
                                                          .day
                                                          .toString() +
                                                      '-' +
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['return_on']
                                                          .toDate()
                                                          .month
                                                          .toString() +
                                                      '-' +
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['return_on']
                                                          .toDate()
                                                          .year
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'Sofia',
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  else
                                    return Container();
                                },
                              );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
