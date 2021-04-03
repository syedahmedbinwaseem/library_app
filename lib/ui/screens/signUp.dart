import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_app/ui/screens/login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final FirebaseAuth mauth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showPass = true;
  bool isLoading = false;
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
      // User users = FirebaseAuth.instance.currentUser;
      print(user.additionalUserInfo.username);

      if (user != null) {
        FirebaseFirestore.instance.collection("user").doc("${email.text}").set({
          'created_at': Timestamp.now(),
          'name': name.text,
          'email': email.text,
          'image': null
        });

        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Registered successfully!',
                  style: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "Continue",
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Sofia'),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                      } catch (e) {
                        print(e);
                      }
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
                    top: height * 0.03,
                    left: width * 0.04,
                    child: IconButton(
                        splashColor: Colors.black12,
                        iconSize: 30,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  Positioned(
                    top: height * 0.12,
                    left: width * 0.08,
                    child: Text(
                      'Sign Up',
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
                              'Create an account',
                              style: TextStyle(
                                fontFamily: 'Sofia',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Name',
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
                              controller: name,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return value.isEmpty ? 'Enter name' : null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter Name',
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
                              controller: email,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Enter email'
                                    : validateEmail(value) == 1
                                        ? 'Invalid email'
                                        : null;
                              },
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
                                  controller: password,
                                  obscureText: showPass,
                                  validator: (value) {
                                    return value.isEmpty
                                        ? 'Enter password'
                                        : null;
                                  },
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
                              height: 40,
                            ),
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () {
                                if (fKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  signup();
                                }
                              },
                              height: width * 0.12,
                              color: Color(0xff0e2f56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: width - width * 0.08,
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Already have an account? ',
                                        style: TextStyle(
                                          fontFamily: 'Sofia',
                                          fontSize: height * 0.02,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Sign In',
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pop(context);
                                          },
                                        style: TextStyle(
                                            fontSize: height * 0.02,
                                            color: Color(0xff0e2f56),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
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
