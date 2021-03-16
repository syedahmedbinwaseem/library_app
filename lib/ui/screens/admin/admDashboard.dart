import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/admin/Books/availableBooks.dart';
import 'package:library_app/ui/screens/login.dart';

class AdDashboard extends StatefulWidget {
  @override
  _AdDashboardState createState() => _AdDashboardState();
}

class _AdDashboardState extends State<AdDashboard> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: Container(
          height: 40,
          child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.power_settings_new_outlined,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Log out',
                    style: TextStyle(
                        fontFamily: 'Sofia', color: Colors.red, fontSize: 24),
                  )
                ],
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (e) {}

                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 20,
        ),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AvailableBooks()));
                  },
                  child: _buildBook(
                    'Available Books',
                    Colors.cyan,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _buildBook(
                  'Registered Users',
                  Colors.blueGrey,
                ),
              ],
            ),
            Column(
              children: [
                _buildBook2('Issued Books', Colors.lightBlue),
                SizedBox(
                  height: 10,
                ),
                _buildBook2('Fine Generator', Colors.blue[300]),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBook(text, color) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.3,
      width: width * 0.45,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBook2(text, color) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.25,
      width: width * 0.45,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
