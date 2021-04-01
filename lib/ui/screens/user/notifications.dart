import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    // .collection('user')
                    // .doc(LocalUser.userData.email)
                    .collection('books')
                    .where('fine', isNull: true)
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
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
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
                                                snapshot.data.docs[index]
                                                    ['name'] +
                                                'of ${snapshot.data.docs[index]['fine'].toString()}',
                                            style: TextStyle(
                                                fontFamily: 'Sofia',
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5),
                                        ],
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
