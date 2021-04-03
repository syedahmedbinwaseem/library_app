import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:library_app/ui/screens/user/localUser.dart';

import 'package:library_app/utils/colors.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyBlue,
      appBar: AppBar(
        backgroundColor: navyBlue,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Sofia',
          ),
        ),
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
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    // .collection('user')
                    // .doc(LocalUser.userData.email)
                    .collection('user')
                    .doc(LocalUser.userData.email)
                    .collection('fine')
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
                                  'No new notifications',
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
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  secondaryActions: snapshot.data.docs[index]
                                              ['seen'] ==
                                          false
                                      ? [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 8),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: SlideAction(
                                                    onTap: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(LocalUser
                                                              .userData.email)
                                                          .collection('fine')
                                                          .doc(snapshot.data
                                                              .docs[index].id)
                                                          .update(
                                                              {'seen': true});
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      color: Colors.green,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .mark_email_read,
                                                              color:
                                                                  Colors.white),
                                                          SizedBox(height: 2),
                                                          Text('Mark as read',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Sofia',
                                                                  color: Colors
                                                                      .white)),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ]
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.15,
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      decoration: BoxDecoration(
                                        color: pink,
                                        borderRadius: BorderRadius.circular(20),
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
                                              'You have been fined for not returnig ' +
                                                  '\'${snapshot.data.docs[index]['bookName']}\'' +
                                                  ' of ${snapshot.data.docs[index]['fineAmount'].toString()}',
                                              style: TextStyle(
                                                fontFamily: 'Sofia',
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
