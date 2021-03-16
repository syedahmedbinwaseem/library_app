import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/admin/Books/editBook.dart';
import 'package:library_app/ui/screens/admin/Books/issueBook.dart';

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
    // TODO: implement initState
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
                    title: Text(snapshot.data['name']),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.edit),
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
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 5),
                        Text(
                          snapshot.data['name'],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Author Name:',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 5),
                        Text(
                          snapshot.data['author'],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Available:',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 5),
                        Text(
                          snapshot.data['available'] == true ? 'Yes' : 'No',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Issued To:',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            child: snapshot.data['issued'].length == 0
                                ? Center(
                                    child: Text(
                                      'Not issued to anyone.\nClick on the button below to issue this book',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data['issued'].length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        child: FlatButton(
                                          onPressed: () {},
                                          minWidth: 110,
                                          padding: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.blueAccent
                                                  .withOpacity(0.4),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Center(
                                              child: Text(
                                                snapshot.data['issued'][index],
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
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
}
