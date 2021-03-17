import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final name = TextEditingController();
  final author = TextEditingController();
  final quantity = TextEditingController();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading = false;

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
                      'Add Book',
                      style: TextStyle(
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                        validator: (input) {
                          return input.isEmpty ? 'Cannot be empty' : null;
                        },
                        style: TextStyle(fontFamily: 'Sofia'),
                        controller: name,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: Colors.grey[700],
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          // disabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: primaryGreen)),
                          labelText: 'Book Name',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sofia',
                              fontSize: 15),
                        )),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (input) {
                          return input.isEmpty ? 'Cannot be empty' : null;
                        },
                        style: TextStyle(fontFamily: 'Sofia'),
                        controller: author,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: Colors.grey[700],
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          // disabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: primaryGreen)),
                          labelText: 'Author Name',
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
                              name.clear();
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
                                setState(() {
                                  isLoading = true;
                                });

                                await FirebaseFirestore.instance
                                    .collection('books')
                                    .doc()
                                    .set(
                                  {
                                    'name': name.text,
                                    'author': author.text,
                                    'added_on': Timestamp.now(),
                                    'issued': '',
                                    'issued_on': null,
                                    'return_on': null
                                  },
                                );

                                Navigator.pop(context);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Text('Save',
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
}
