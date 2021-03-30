import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class DeleteUser extends StatefulWidget {
  String docId;

  DeleteUser({this.docId});
  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Dialog(
        insetPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Warning',
                  style: TextStyle(
                      color: Colors.red, fontSize: 20, fontFamily: 'Sofia'),
                ),
                SizedBox(height: 10),
                Text(
                  'Are you sure you want to remove this user?',
                  style: TextStyle(
                      color: Colors.black, fontSize: 15, fontFamily: 'Sofia'),
                ),
                SizedBox(height: 10),
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ignore: deprecated_member_use
                        FlatButton(
                          minWidth: 30,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontFamily: 'Sofia',
                            ),
                          ),
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          minWidth: 30,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection('books')
                                .get();
                            List<DocumentSnapshot> books = [];
                            snap.docs.forEach((element) {
                              if (element['issued'] == widget.docId) {
                                // print(element.id);
                                books.add(element);
                              }
                            });

                            if (books.length == 0) {
                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(widget.docId)
                                  .delete();

                              Navigator.pop(context);
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              Navigator.pop(context);
                              warningDialog(books);
                            }

                            // Navigator.pop(context);
                            // setState(() {
                            //   isLoading = false;
                            // });
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  warningDialog(books) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(13),
              height: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Warning!',
                    style: TextStyle(fontSize: 23, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Follwoing book(s) are issued to this user:',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Sofia',
                    ),
                  ),
                  Container(
                    height: 80,
                    child: ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              books[index]['name'],
                              style: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Are you sure you want to remove?',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Sofia',
                    ),
                  ),
                  SizedBox(height: 0),
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ignore: deprecated_member_use
                        FlatButton(
                          minWidth: 30,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontFamily: 'Sofia',
                            ),
                          ),
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          minWidth: 30,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(widget.docId)
                                .delete();

                            Navigator.pop(context);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                                fontFamily: 'Sofia', color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
