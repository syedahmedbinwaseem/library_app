import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:library_app/ui/screens/user/issued.dart';

import 'package:library_app/ui/screens/user/localUser.dart';
import 'package:library_app/ui/screens/user/profile.dart';

class DrawerApp extends StatefulWidget {
  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  @override
  Widget build(BuildContext context) {
   // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: width * 0.55,
            width: width,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc(LocalUser.userData.email)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: width * 0.25,
                        width: width * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        height: width * 0.05,
                      ),
                      Text(
                        snapshot.data['name'],
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontFamily: 'Sofia',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: width * 0.01,
                      ),
                      Text(
                        snapshot.data['email'],
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontFamily: 'Sofia',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.black54,
                ),
                SizedBox(width: 15),
                Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'Sofia', color: Colors.black54, fontSize: 24),
                )
              ],
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          Divider(),
          TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.book_outlined,
                  color: Colors.black54,
                ),
                SizedBox(width: 15),
                Text(
                  'Issued Books',
                  style: TextStyle(
                      fontFamily: 'Sofia', color: Colors.black54, fontSize: 24),
                )
              ],
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Issued()));
            },
          ),
          Divider(),
          TextButton(
              child: Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Notifications',
                    style: TextStyle(
                        fontFamily: 'Sofia',
                        color: Colors.black54,
                        fontSize: 24),
                  )
                ],
              ),
              onPressed: () {}),
        ],
      ),
    );
  }
}
