import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditBook extends StatefulWidget {
  DocumentSnapshot book;

  EditBook({this.book});
  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final name = TextEditingController();
  final author = TextEditingController();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool available;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.book['name'];
    author.text = widget.book['author'];
    available = widget.book['available'];
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
                        textInputAction: TextInputAction.next,
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          available = !available;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: available,
                            onChanged: (value) {
                              setState(() {
                                available = !available;
                              });
                            },
                          ),
                          Text('Available')
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                    .doc(widget.book.id)
                                    .update({
                                  'name': name.text,
                                  'author': author.text,
                                  'available': available
                                });
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
