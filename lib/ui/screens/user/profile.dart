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
          elevation: 0,
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
            return Column(
              children: [
                Container(
                  height: width * 0.5,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        height: 15,
                      ),
                      Text(
                        snapshot.data['name'],
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          color: Colors.white,
                          fontFamily: 'Sofia',
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(
                              fontFamily: 'Sofia',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                          ),
                          Text(
                            snapshot.data['email'],
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
