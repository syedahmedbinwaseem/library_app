import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_app/ui/screens/admin/admDashboard.dart';
import 'package:library_app/ui/screens/signUp.dart';
import 'package:library_app/ui/screens/user/bottomavigator.dart';

import 'package:library_app/ui/screens/user/localUser.dart';
import 'package:library_app/utils/colors.dart';
import 'package:library_app/utils/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgot = TextEditingController();
  GlobalKey<FormState> fKey1 = GlobalKey<FormState>();
  bool isLoadingForgot = false;
  FToast fToast;
  bool showPass = true;
  bool isLoading = false;
  void toggle() {
    setState(() {
      showPass = !showPass;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
            if (user != null) {
              try {
                DocumentSnapshot snap = await FirebaseFirestore.instance
                    .collection("user")
                    .doc(email.text)
                    .get();
                LocalUser.userData.name = snap['name'].toString();
                LocalUser.userData.email = snap['email'].toString();
                snap.data().containsKey('image')
                    ? LocalUser.userData.image = snap['image']
                    : LocalUser.userData.image = null;
              } catch (e) {
                print(e);
              }
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavigator()),
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
          backgroundColor: Color(0xff0e2f56),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: height * 0.2,
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(0xff0e2f56),
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
                        fontFamily: 'Sofia',
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
                                fontFamily: 'Sofia',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Hello there, Signin to continue!',
                              style: TextStyle(
                                fontFamily: 'Sofia',
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
                                fontFamily: 'Sofia',
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              style: TextStyle(fontFamily: 'Sofia'),
                              keyboardType: TextInputType.emailAddress,
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
                                hintText: 'Enter email',
                                hintStyle: TextStyle(
                                  fontFamily: 'Sofia',
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
                                fontFamily: 'Sofia',
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
                                  style: TextStyle(fontFamily: 'Sofia'),
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
                                      fontFamily: 'Sofia',
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
                            GestureDetector(
                              onTap: () {
                                print('asa');
                                generateBottomSheet(context, 10);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 16,
                                  color: Color(0xff0e2f56),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () {
                                if (fKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  logIn();
                                }
                              },
                              height: width * 0.12,
                              color: Color(0xff0e2f56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
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
                                          fontFamily: 'Sofia',
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
                                            fontFamily: 'Sofia',
                                            fontSize: height * 0.02,
                                            color: Color(0xff0e2f56),
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

  generateBottomSheet(conext, double padding) {
    // FocusScope.of(context).unfocus();
    showModalBottomSheet(
        isScrollControlled: true,

        // isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 30, bottom: 20),
                      child: Form(
                        key: fKey1,
                        child: Wrap(
                          spacing: 20,
                          children: [
                            Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontFamily: 'Sofia',
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(fontFamily: 'Sofia'),
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Email is required'
                                    : validateEmail(value) == 1
                                        ? 'Invalid email'
                                        : null;
                              },
                              controller: forgot,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.red,
                                    fontSize: 14),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                            ),
                            SizedBox(height: 30),
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () async {
                                if (fKey1.currentState.validate()) {
                                  try {
                                    setState(() {
                                      isLoadingForgot = true;
                                    });
                                    final FirebaseAuth _firebaseAuth =
                                        FirebaseAuth.instance;
                                    await _firebaseAuth.sendPasswordResetEmail(
                                        email: forgot.text.toString());
                                    fToast.showToast(
                                      child: ToastWidget.toast(
                                          'Password reset link sent on your email',
                                          Icon(Icons.done, size: 20)),
                                      toastDuration: Duration(seconds: 2),
                                      gravity: ToastGravity.BOTTOM,
                                    );

                                    setState(() {
                                      isLoadingForgot = false;
                                    });
                                    Navigator.pop(context);
                                  } catch (e) {
                                    Navigator.pop(context);

                                    setState(() {
                                      isLoadingForgot = false;
                                    });
                                    if (e.code == 'too-many-requests') {
                                      fToast.showToast(
                                        child: ToastWidget.toast(
                                            'You are trying too often. Please try again later',
                                            Icon(Icons.error, size: 20)),
                                        toastDuration: Duration(seconds: 2),
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    } else {
                                      fToast.showToast(
                                        child: ToastWidget.toast(
                                            'Operation failed. Try again later',
                                            Icon(Icons.error, size: 20)),
                                        toastDuration: Duration(seconds: 2),
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  }
                                }
                              },
                              height: 40,
                              color: navyBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: isLoadingForgot == true
                                    ? Container(
                                        height: 40,
                                        width: 40,
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'RESET',
                                        style: TextStyle(
                                            fontFamily: 'Sofia',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      )));
            },
          );
        }).then((value) {
      forgot.clear();
      FocusScope.of(context).unfocus();
    });
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
