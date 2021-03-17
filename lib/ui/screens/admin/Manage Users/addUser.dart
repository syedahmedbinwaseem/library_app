import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_app/ui/screens/login.dart';
import 'package:library_app/ui/screens/signUp.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPass = true;

  void toggle() {
    setState(() {
      showPass = !showPass;
    });
  }

  void signup() async {
    setState(() {
      isLoading = true;
    });
    try {
      // ignore: unused_local_variable
      UserCredential user = await mauth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      if (user != null) {
        FirebaseFirestore.instance.collection("user").doc("${email.text}").set({
          'created_at': Timestamp.now(),
          'name': name.text,
          'email': email.text,
        });

        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'User added successfully!',
                  style: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "OK",
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Sofia'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }).then((value) async {
          try {
            await FirebaseAuth.instance.signOut();
          } catch (e) {
            print(e);
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'Email Already in use',
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Error: " + e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Dialog(
            child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(10),
              child: Form(
                key: fKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add User',
                      style: TextStyle(
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                        validator: (input) {
                          return input.isEmpty ? 'Enter name' : null;
                        },
                        style: TextStyle(fontFamily: 'Sofia'),
                        controller: name,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.grey[700],
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          // disabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: primaryGreen)),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sofia',
                              fontSize: 15),
                        )),
                    TextFormField(
                        validator: (input) {
                          return input.isEmpty
                              ? 'Enter email'
                              : validateEmail(input) == 1
                                  ? 'Invalid email'
                                  : null;
                        },
                        style: TextStyle(fontFamily: 'Sofia'),
                        controller: email,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.grey[700],
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          // disabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: primaryGreen)),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sofia',
                              fontSize: 15),
                        )),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (input) {
                          return input.isEmpty
                              ? 'Enter password'
                              : input.length < 6
                                  ? 'Password should be at least 6 characters'
                                  : null;
                        },
                        obscureText: showPass,
                        style: TextStyle(fontFamily: 'Sofia'),
                        controller: password,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.grey[700],
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: showPass
                                ? Icon(Icons.visibility_off, size: 16)
                                : Icon(Icons.visibility, size: 16),
                            onPressed: toggle,
                          ),
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          // disabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: primaryGreen)),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sofia',
                              fontSize: 15),
                        )),
                    SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // ignore: deprecated_member_use
                          FlatButton(
                            minWidth: 40,
                            onPressed: () {
                              email.clear();
                              password.clear();
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    fontWeight: FontWeight.bold)),
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            minWidth: 40,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (fKey.currentState.validate()) {
                                signup();
                              }
                            },
                            child: Text('Add',
                                style: TextStyle(
                                    fontFamily: "Sofia",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )));
  }

  int validateEmail(String value) {
    if (value.isEmpty) return 2;

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return 1;
    }
    return 0;
  }
}
