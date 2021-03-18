

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';


import 'package:library_app/ui/screens/user/localUser.dart';

class Profile extends StatefulWidget {
 
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();

 

  @override
  Widget build(BuildContext context) {
   // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: Icon(
                Icons.edit,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(LocalUser.userData.email)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: width * 0.5,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: width * 0.25,
                          width: width * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          snapshot.data['name'],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
