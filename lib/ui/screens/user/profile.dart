import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/ui/screens/login.dart';
import 'package:library_app/ui/screens/user/localUser.dart';
import 'package:library_app/utils/colors.dart';
import 'package:library_app/utils/toast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Profile'),
          elevation: 0,
          backgroundColor: navyBlue,
          actions: [
            Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    generateBottomSheet(MediaQuery.of(context).size.height,
                        MediaQuery.of(context).size.width);
                  },
                )),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(LocalUser.userData.email)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: width * 0.5,
                        width: width,
                        decoration: BoxDecoration(
                          color: navyBlue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: width * 0.222222,
                              width: width * 0.222222,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * 0.111111),
                                color: Colors.white,
                              ),
                              padding:
                                  snapshot.data.data().containsKey('image') ==
                                              true &&
                                          snapshot.data['image'] != null
                                      ? EdgeInsets.all(0)
                                      : EdgeInsets.all(10),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.111111),
                                  child: snapshot.data
                                                  .data()
                                                  .containsKey('image') ==
                                              true &&
                                          snapshot.data['image'] != null
                                      ? CachedNetworkImage(
                                          imageUrl: snapshot.data['image'],
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: SizedBox(
                                              height: width * 0.09722,
                                              width: width * 0.09722,
                                              child: CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(navyBlue),
                                                  strokeWidth: 3,
                                                  value: downloadProgress
                                                      .progress),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : Image.asset('assets/images/user.png')),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              snapshot.data['name'],
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.08,
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
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data['email'],
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045),
                                ),
                                SizedBox(height: 20),
                                TextButton(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.power_settings_new_outlined,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Log out',
                                          style: TextStyle(
                                              fontFamily: 'Sofia',
                                              color: Colors.red,
                                              fontSize: 24),
                                        )
                                      ],
                                    ),
                                    onPressed: () async {
                                      try {
                                        await FirebaseAuth.instance.signOut();
                                      } catch (e) {}

                                      Navigator.of(context, rootNavigator: true)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    }),
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

  final picker = ImagePicker();

  bool imageValue = false;
  bool isLoading = false;
  FToast fToast;
  File _image;
  bool added = false;
  String imagePath;

  Future uploadFile() async {
    if (_image == null) {
      return 'as';
    } else {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('User Images/${Timestamp.now().toString()}');
        UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.whenComplete(() async {
          await storageReference.getDownloadURL().then((value) {
            imagePath = value;
          });
        });
        LocalUser.userData.image = imagePath;
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'not',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 15,
        );
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          added = true;
        });
      } else {
        fToast.showToast(
          child: ToastWidget.toast(
              'Cannot add image', Icon(Icons.error, size: 20)),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }

  generateBottomSheet(double height, double width) {
    TextEditingController name =
        TextEditingController(text: LocalUser.userData.name);

    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  // height: MediaQuery.of(context).size.height - height,
                  child: Form(
                    key: fKey,
                    child: Wrap(
                      spacing: 20,
                      children: [
                        // SizedBox(height: 20),
                        Center(
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: width * 0.2777777,
                                  width: width * 0.2777777,

                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.138888),
                                    color: Colors.blue.withOpacity(0.3),
                                  ),
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                    padding: LocalUser.userData.image == null &&
                                            added == false &&
                                            _image == null
                                        ? EdgeInsets.all(10)
                                        : EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          width * 0.138888),
                                    ),
                                    onHighlightChanged: (value) {
                                      setState(() {
                                        imageValue = value;
                                      });
                                    },
                                    onPressed: () {
                                      getImage().then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            width * 0.138888),
                                        child: Center(
                                            child: LocalUser.userData.image !=
                                                        null &&
                                                    added == false
                                                ? CachedNetworkImage(
                                                    imageUrl: LocalUser
                                                        .userData.image,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Center(
                                                      child: SizedBox(
                                                        height: width * 0.09722,
                                                        width: width * 0.09722,
                                                        child: CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    navyBlue),
                                                            strokeWidth: 3,
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  )
                                                : _image == null ||
                                                        _image.toString() == ''
                                                    ? Image.asset(
                                                        'assets/images/user.png')
                                                    : Image.file(
                                                        _image,
                                                        fit: BoxFit.cover,
                                                      ))),
                                  ),
                                ),
                              ),
                              imageValue == true
                                  ? Center(
                                      child: Container(
                                        height: width * 0.2777777,
                                        width: width * 0.2777777,
                                        color: Colors.white.withOpacity(0.3),
                                        child: Center(child: Icon(Icons.edit)),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              LocalUser.userData.email,
                              style: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: width * 0.04166),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(fontFamily: 'Sofia'),
                          validator: (value) {
                            return value.isEmpty ? 'Name is required' : null;
                          },
                          controller: name,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                fontFamily: 'Sofia',
                                color: Colors.red,
                                fontSize: 14),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                                fontFamily: 'Sofia',
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ),

                        SizedBox(height: 20),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isLoading = true;
                            });
                            if (fKey.currentState.validate()) {
                              // logIn();
                              LocalUser.userData.name = name.text;

                              await uploadFile().then((value) {
                                // imagePath == null
                                //     ? null
                                //     : LocalUser.userData.image =
                                //         imagePath;

                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(LocalUser.userData.email)
                                    .update({
                                  'name': name.text,

                                  // imagePath == null ? null : 'image':
                                  //     imagePath
                                  'image': imagePath == null
                                      ? LocalUser.userData.image
                                      : imagePath
                                });
                                fToast.showToast(
                                  child: ToastWidget.toast('Profile updated',
                                      Icon(Icons.done, size: 20)),
                                  toastDuration: Duration(seconds: 2),
                                  gravity: ToastGravity.BOTTOM,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          height: 40,
                          color: navyBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: isLoading == true
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    'SAVE',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).then((value) {
      setState(() {
        isLoading = false;
        added = false;
        _image = null;
        imagePath = null;
      });
    });
  }
}
