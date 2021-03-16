import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_app/ui/screens/admin/admDashboard.dart';
import 'package:library_app/ui/screens/admin/adminDashboard.dart';
import 'package:library_app/ui/screens/signUp.dart';
import 'package:library_app/ui/screens/user/dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showPass = true;
  bool isLoading = false;
  void toggle() {
    setState(() {
      showPass = !showPass;
    });
  }

  void logIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .doc("user/${email.text}")
          .get()
          .then((doc) async {
        if (doc.exists) {
          try {
            // ignore: unused_local_variable
            UserCredential user = await mauth.signInWithEmailAndPassword(
                email: email.text, password: password.text);
            setState(() {
              isLoading = false;
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => UserDashboard()),
                (route) => false);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              setState(() {
                isLoading = false;
              });
              print('user not found');

              Fluttertoast.showToast(
                msg: "User not found for this email",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red[400],
                textColor: Colors.white,
                fontSize: 15,
              );
            } else if (e.code == 'wrong-password') {
              setState(() {
                isLoading = false;
              });

              Fluttertoast.showToast(
                msg: "Wrong password",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 15,
              );
            }
          } catch (e) {
            setState(() {
              isLoading = false;
            });

            print("Error: " + e);
          }
        } else {
          try {
            await FirebaseFirestore.instance
                .doc("admin/${email.text}")
                .get()
                .then((doc) async {
              if (doc.exists) {
                try {
                  // ignore: unused_local_variable
                  UserCredential user = await mauth.signInWithEmailAndPassword(
                      email: email.text, password: password.text);
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AdDashboard()),
                      (route) => false);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    setState(() {
                      isLoading = false;
                    });

                    Fluttertoast.showToast(
                      msg: "User not found for this email",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red[400],
                      textColor: Colors.white,
                      fontSize: 15,
                    );
                  } else if (e.code == 'wrong-password') {
                    setState(() {
                      isLoading = false;
                    });

                    Fluttertoast.showToast(
                      msg: "Wrong password",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 15,
                    );
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });

                  print("Error: " + e);
                }
              } else {
                setState(() {
                  isLoading = false;
                });

                Fluttertoast.showToast(
                  msg: "User not found for this email",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 15,
                );
              }
            });
          } catch (e) {
            setState(() {
              isLoading = false;
            });

            print(e);
          }
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.blue,
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: height * 0.2,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    top: height * 0.03,
                    left: width * 0.85,
                    child: CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: height * 0.08,
                    ),
                  ),
                  Positioned(
                    bottom: height * 0.07,
                    left: width * 0.75,
                    child: CircleAvatar(
                      radius: height * 0.08,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Positioned(
                    top: height * 0.12,
                    left: width * 0.08,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Form(
                    key: fKey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Hello there, signin to continue!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Username or email',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Enter email'
                                    : validateEmail(value) == 1
                                        ? 'Invalid email'
                                        : null;
                              },
                              controller: email,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: 'Enter Username or email',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black38,
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Stack(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    return value.isEmpty
                                        ? ' Enter password'
                                        : null;
                                  },
                                  controller: password,
                                  obscureText: showPass,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Password',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black38,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: height * 0.005,
                                  left: width * 0.73,
                                  child: IconButton(
                                    color: Colors.black38,
                                    icon: showPass
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                    onPressed: toggle,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Fogot Password?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            FlatButton(
                              onPressed: () {
                                if (fKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  logIn();
                                }
                              },
                              height: width * 0.12,
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: width - width * 0.08,
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Don\'t have an account? ',
                                        style: TextStyle(
                                          fontSize: height * 0.02,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Sign Up',
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignUp()));
                                          },
                                        style: TextStyle(
                                            fontSize: height * 0.02,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
