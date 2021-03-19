import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/admin/admDashboard.dart';
import 'package:library_app/ui/screens/login.dart';
import 'package:library_app/ui/screens/user/dashboard.dart';
import 'package:library_app/ui/screens/user/localUser.dart';

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

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserDashboard()));
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
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/library.png'),
              ),
              SizedBox(height: 30),
              Text(
                'InfyLMS',
                style: TextStyle(
                    fontSize: 40, color: Colors.blue, fontFamily: 'Sofia'),
              ),
              SizedBox(height: 5),
              Text(
                'POWERFUL LIBRARY MANAGEMENT',
                style: TextStyle(
                    fontSize: 15, color: Colors.blue, fontFamily: 'Sofia'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
