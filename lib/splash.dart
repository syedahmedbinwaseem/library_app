import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/admin/admDashboard.dart';
import 'package:library_app/ui/screens/login.dart';
import 'package:library_app/ui/screens/user/bottomavigator.dart';
import 'package:library_app/ui/screens/user/localUser.dart';
import 'package:library_app/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getUser() async {
    Firebase.initializeApp().then((value) async {
      User user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        try {
          await FirebaseFirestore.instance
              .doc("user/${user.email}")
              .get()
              .then((doc) async {
            if (doc.exists) {
              DocumentSnapshot snap = await FirebaseFirestore.instance
                  .collection("user")
                  .doc(user.email)
                  .get();
              LocalUser.userData.name = snap['name'].toString();
              LocalUser.userData.email = snap['email'].toString();
              snap.data().containsKey('image')
                  ? LocalUser.userData.image = snap['image']
                  : LocalUser.userData.image = null;

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BottomNavigator()));
            } else {
              try {
                await FirebaseFirestore.instance
                    .doc("admin/${user.email}")
                    .get()
                    .then((doc) {
                  if (doc.exists) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AdDashboard()));
                  } else {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                });
              } catch (e) {}
            }
          });
        } catch (e) {}
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/library.png'),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ILM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        color: navyBlue,
                        fontFamily: 'Sofia',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Connect,Discover & Learn',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        color: pink,
                        fontFamily: 'Sofia',
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
