import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/login.dart';

class DrawerApp extends StatefulWidget {
  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: TextButton(
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
    );
  }
}
