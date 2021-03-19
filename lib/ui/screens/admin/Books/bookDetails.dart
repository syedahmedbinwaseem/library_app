import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:library_app/ui/screens/admin/Books/editBook.dart';
import 'package:library_app/ui/screens/admin/Books/issueBook.dart';
import 'package:library_app/ui/screens/admin/Books/returnedBook.dart';
import 'package:library_app/ui/screens/admin/Fines/generateFine.dart';

// ignore: must_be_immutable
class BookDetails extends StatefulWidget {
  DocumentSnapshot book;

  BookDetails({this.book});
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  DocumentSnapshot snap;

  @override
  void initState() {
    super.initState();
    snap = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('books')
            .doc(widget.book.id)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
                  floatingActionButton: issueBook(snapshot.data.id),
                  appBar: AppBar(
                    title: Text(
                      snapshot.data['name'],
                      style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                          ),
                          onPressed: () {
                            editBooks(snapshot.data);
                          })
                    ],
                  ),
                  body: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book Name:',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Sofia',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          snapshot.data['name'],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sofia',
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Author Name:',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Sofia',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          snapshot.data['author'],
                          style: TextStyle(
                              fontFamily: 'Sofia',
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Available:',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Sofia',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          snapshot.data['issued'] == '' ? 'Yes' : 'No',
                          style: TextStyle(
                              fontFamily: 'Sofia',
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Issue Details:',
                          style: TextStyle(fontFamily: 'Sofia', fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        snapshot.data['issued'] == ''
                            ? Expanded(
                                child: Center(
                                    child: Text(
                                'Not issued to anyone.\nClick on the button below to issue this book.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Sofia',
                                ),
                              )))
                            : Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                secondaryActions: DateTime.now().compareTo(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                snapshot.data['return_on']
                                                    .microsecondsSinceEpoch)) ==
                                        -1
                                    ? [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Container(
                                            height: DateTime.now().compareTo(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            snapshot
                                                                .data[
                                                                    'return_on']
                                                                .microsecondsSinceEpoch)) ==
                                                    -1
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                            width: DateTime.now().compareTo(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            snapshot
                                                                .data[
                                                                    'return_on']
                                                                .microsecondsSinceEpoch)) ==
                                                    -1
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: SlideAction(
                                                  onTap: () {
                                                    returnedBook(
                                                        snapshot.data.id);
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: Colors.green,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.done,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(height: 2),
                                                        Text('Returned',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Sofia',
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ]
                                    : [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Container(
                                            height: DateTime.now().compareTo(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            snapshot
                                                                .data[
                                                                    'return_on']
                                                                .microsecondsSinceEpoch)) ==
                                                    -1
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                            width: DateTime.now().compareTo(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            snapshot
                                                                .data[
                                                                    'return_on']
                                                                .microsecondsSinceEpoch)) ==
                                                    -1
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                                child: SlideAction(
                                                  onTap: () {
                                                    returnedBook(
                                                        snapshot.data.id);
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: Colors.green,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.done,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(height: 2),
                                                        Text('Returned',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Sofia',
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                    onPressed: () {},
                                    minWidth: 110,
                                    padding: EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: DateTime.now().compareTo(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      snapshot.data['return_on']
                                                          .microsecondsSinceEpoch)) ==
                                              -1
                                          ? MediaQuery.of(context).size.width *
                                              0.5
                                          : MediaQuery.of(context).size.width *
                                              0.6,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: DateTime.now().compareTo(DateTime
                                                      .fromMicrosecondsSinceEpoch(
                                                          snapshot
                                                              .data['return_on']
                                                              .microsecondsSinceEpoch)) ==
                                                  -1
                                              ? Colors.blueAccent
                                                  .withOpacity(0.4)
                                              : Colors.redAccent
                                                  .withOpacity(0.4)),
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Issued To:',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Sofia',
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                Text(
                                                  snapshot.data['issued'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Sofia',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            // SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Text(
                                                  'Issued On:',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Sofia',
                                                  ),
                                                ),
                                                SizedBox(width: 30),
                                                Text(
                                                  snapshot.data['issued_on']
                                                          .toDate()
                                                          .day
                                                          .toString() +
                                                      '-' +
                                                      snapshot.data['issued_on']
                                                          .toDate()
                                                          .month
                                                          .toString() +
                                                      '-' +
                                                      snapshot.data['issued_on']
                                                          .toDate()
                                                          .year
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Sofia',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Return On:',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Sofia',
                                                  ),
                                                ),
                                                SizedBox(width: 30),
                                                Text(
                                                  snapshot.data['return_on']
                                                          .toDate()
                                                          .day
                                                          .toString() +
                                                      '-' +
                                                      snapshot.data['return_on']
                                                          .toDate()
                                                          .month
                                                          .toString() +
                                                      '-' +
                                                      snapshot.data['return_on']
                                                          .toDate()
                                                          .year
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Sofia',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            DateTime.now().compareTo(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            snapshot
                                                                .data[
                                                                    'return_on']
                                                                .microsecondsSinceEpoch)) ==
                                                    -1
                                                ? Container()
                                                : SizedBox(height: 5),
                                            DateTime.now().compareTo(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            snapshot
                                                                .data[
                                                                    'return_on']
                                                                .microsecondsSinceEpoch)) ==
                                                    -1
                                                ? Container()
                                                : Divider(
                                                    thickness: 1,
                                                  ),
                                            DateTime.now().compareTo(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            snapshot
                                                                .data[
                                                                    'return_on']
                                                                .microsecondsSinceEpoch)) ==
                                                    -1
                                                ? Container()
                                                : Row(
                                                    children: [
                                                      Text(
                                                        'Book Returned Date overdue',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: 'Sofia',
                                                        ),
                                                      ),
                                                    ],
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
                  ));
        });
  }

  issueBook(String docId) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return IssueBook(
                docId: docId,
              );
            });
      },
      child: Center(
        child: Icon(Icons.add),
      ),
    );
  }

  editBooks(DocumentSnapshot docId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return EditBook(book: docId);
        });
  }

  generateFine(DocumentSnapshot book) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return GenerateFine(
            book: book,
          );
        });
  }

  returnedBook(String docId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ReturnedBook(docId: docId);
        });
  }
}
