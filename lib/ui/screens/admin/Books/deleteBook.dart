import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class DeleteBook extends StatefulWidget {
  String docId;

  DeleteBook({this.docId});
  @override
  _DeleteBookState createState() => _DeleteBookState();
}

class _DeleteBookState extends State<DeleteBook> {
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
                  'Are you sure you want to delete the book?',
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

                            await FirebaseFirestore.instance
                                .collection('books')
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
}
