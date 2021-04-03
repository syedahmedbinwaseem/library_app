import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/admin/Books/availableBooks.dart';
import 'package:library_app/ui/screens/admin/Books/issuedBooks.dart';
import 'package:library_app/ui/screens/admin/Fines/notreturnedBooks.dart';
import 'package:library_app/ui/screens/admin/Manage%20Users/users.dart';
import 'package:library_app/ui/screens/login.dart';
import 'package:library_app/utils/colors.dart';

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
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'Sofia',
            fontSize: 22,
          ),
        ),
        backgroundColor: navyBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Are you sure you want to logout',
                      style: TextStyle(color: navyBlue, fontFamily: 'Sofia'),
                    ),
                    actions: [
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style:
                              TextStyle(color: navyBlue, fontFamily: 'Sofia'),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                          } catch (e) {}

                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          'Yes',
                          style:
                              TextStyle(color: navyBlue, fontFamily: 'Sofia'),
                        ),
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
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
                _buildBook('Available Books', Colors.cyan, 1),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  child: _buildBook('Registered Users', Colors.blueGrey, 2),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IssuedBooks()));
                    },
                    child: _buildBook2('Issued Books', Colors.lightBlue, 1)),
                SizedBox(
                  height: 10,
                ),
                _buildBook2('Fine Generator', Colors.blue[300], 2),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBook(text, color, check) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return RaisedButton(
      elevation: 0,
      focusElevation: 500,
      onPressed: () {
        if (check == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AvailableBooks()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Users()));
        }
      },
      // minWidth: 110,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: height * 0.35,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Center(
                child: Container(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: check == 1
                        ? Image.asset('assets/images/basket.png')
                        : Image.asset('assets/images/team.png'),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 46,
                    width: width,
                    decoration: BoxDecoration(
                        color: check == 1
                            ? Colors.cyanAccent.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBook2(text, color, check) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return RaisedButton(
      elevation: 0,
      focusElevation: 500,
      onPressed: () {
        if (check == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IssuedBooks()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BooksNotReturned()));
        }
      },
      // minWidth: 110,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
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
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Container(
                height: 80,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: check == 1
                      ? Image.asset('assets/images/reserved.png')
                      : Image.asset('assets/images/fine.png'),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 46,
                  width: width,
                  decoration: BoxDecoration(
                      color: check == 1
                          ? Colors.blueGrey.withOpacity(0.3)
                          : Colors.cyan.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Sofia',
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
