import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class GenerateFine extends StatefulWidget {
  DocumentSnapshot book;
  GenerateFine({this.book});
  @override
  _GenerateFineState createState() => _GenerateFineState();
}

class _GenerateFineState extends State<GenerateFine> {
  final amount = TextEditingController();
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
                      'Generate Fine',
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
                        controller: amount,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.grey[700],
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.red,
                              fontSize: 14),
                          labelText: 'Fine Amount',
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
                              amount.clear();
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
                                DocumentReference ref = FirebaseFirestore
                                    .instance
                                    .collection('user')
                                    .doc(widget.book['issued'])
                                    .collection('fine')
                                    .doc();
                                ref.set({
                                  'bookName': widget.book['name'],
                                  'fineGeneratedOn': DateTime.now(),
                                  'fineAmount': int.parse(amount.text),
                                });
                                await FirebaseFirestore.instance
                                    .collection('books')
                                    .doc(widget.book.id)
                                    .update({
                                  'fine': int.parse(amount.text),
                                  'fineID': ref.id
                                });

                                Navigator.pop(context);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Text('Generate',
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
