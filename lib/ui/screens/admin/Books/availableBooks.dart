import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:library_app/ui/screens/admin/Books/addBook.dart';
import 'package:library_app/ui/screens/admin/Books/bookDetails.dart';
import 'package:library_app/ui/screens/admin/Books/deleteBook.dart';
import 'package:library_app/ui/screens/admin/Books/editBook.dart';

class AvailableBooks extends StatefulWidget {
  @override
  _AvailableBooksState createState() => _AvailableBooksState();
}

class _AvailableBooksState extends State<AvailableBooks> {
  TextEditingController searchItems = TextEditingController();
  String keyword = '';

  @override
  void initState() {
    super.initState();
    searchItems.addListener(() {
      setState(() {
        keyword = searchItems.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Availavle Books',
            style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
          ),
        ),
        floatingActionButton: addBooks(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 75),
          child: Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('books')
                        .where('issued', isEqualTo: '')
                        .orderBy('added_on', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return !snapshot.hasData
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Stack(
                                    children: [
                                      TextField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: searchItems,
                                        style: TextStyle(fontFamily: 'Sofia'),
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                Icons.clear,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                searchItems.clear();
                                              },
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(top: 17),
                                            prefixIcon: Icon(Icons.search),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: 'Search',
                                            hintStyle:
                                                TextStyle(fontFamily: 'Sofia')),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      if (snapshot.data.docs[index]['name']
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  keyword.toLowerCase()) ||
                                          snapshot.data.docs[index]['author']
                                              .toString()
                                              .toLowerCase()
                                              .contains(keyword.toLowerCase()))
                                        return Slidable(
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          secondaryActions: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10)),
                                                    child: SlideAction(
                                                      onTap: () {
                                                        editBooks(snapshot
                                                            .data.docs[index]);
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        color: Colors.grey,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons.edit,
                                                                color: Colors
                                                                    .white),
                                                            SizedBox(height: 2),
                                                            Text('Edit',
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  child: SlideAction(
                                                    onTap: () {
                                                      deleteBooks(snapshot
                                                          .data.docs[index].id);
                                                    },
                                                    child: Container(
                                                      color: Colors.red,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(Icons.delete,
                                                              color:
                                                                  Colors.white),
                                                          SizedBox(height: 2),
                                                          Text('Delete',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Sofia',
                                                                  color: Colors
                                                                      .white)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 10),
                                            // ignore: deprecated_member_use
                                            child: FlatButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookDetails(
                                                              book: snapshot
                                                                  .data
                                                                  .docs[index],
                                                            )));
                                              },
                                              minWidth: 110,
                                              padding: EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.blueAccent
                                                      .withOpacity(0.4),
                                                ),
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                          fontFamily: 'Sofia',
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['author'],
                                                      style: TextStyle(
                                                          fontFamily: 'Sofia',
                                                          fontSize: 20,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Expanded(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Text(
                                                              'Available',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Sofia',
                                                                fontSize: 16,
                                                              ),
                                                            )))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      else
                                        return Container();
                                    },
                                  ),
                                ),
                              ],
                            );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  addBooks() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AddBook();
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

  deleteBooks(String docId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return DeleteBook(
            docId: docId,
          );
        });
  }
}
