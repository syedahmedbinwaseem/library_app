import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:library_app/ui/screens/admin/Books/returnedBook.dart';
import 'package:library_app/ui/screens/admin/Fines/generateFine.dart';
import 'package:library_app/ui/screens/admin/Fines/payFine.dart';

class BooksNotReturned extends StatefulWidget {
  @override
  _BooksNotReturnedState createState() => _BooksNotReturnedState();
}

class _BooksNotReturnedState extends State<BooksNotReturned> {
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
            'Overdue Books',
            style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: TextField(
                              textCapitalization: TextCapitalization.none,
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
                                  contentPadding: EdgeInsets.only(top: 17),
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: 'Search',
                                  hintStyle: TextStyle(fontFamily: 'Sofia')),
                            ),
                          ),
                          SizedBox(height: 5),
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return snapshot.data.docs[index]['issued'] ==
                                          ''
                                      ? Container()
                                      : DateTime.now().compareTo(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['return_on']
                                                          .microsecondsSinceEpoch)) ==
                                              -1
                                          ? Container()
                                          : snapshot.data.docs[index]['name']
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(keyword
                                                          .toLowerCase()) ||
                                                  snapshot.data
                                                      .docs[index]['issued']
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(
                                                          keyword.toLowerCase())
                                              ? Slidable(
                                                  actionPane:
                                                      SlidableDrawerActionPane(),
                                                  secondaryActions: snapshot
                                                              .data.docs[index]
                                                              .data()
                                                              .containsKey(
                                                                  'fine') &&
                                                          snapshot.data.docs[
                                                                      index]
                                                                  ['fine'] !=
                                                              null
                                                      ? [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8),
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child:
                                                                      SlideAction(
                                                                    onTap: () {
                                                                      payFine(snapshot
                                                                          .data
                                                                          .docs[index]);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      color: Colors
                                                                          .green,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                              Icons.done,
                                                                              color: Colors.white),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Text(
                                                                              'Fine Paid',
                                                                              style: TextStyle(fontFamily: 'Sofia', color: Colors.white)),
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
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8),
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      SlideAction(
                                                                    onTap: () {
                                                                      returnedBook(snapshot
                                                                          .data
                                                                          .docs[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      color: Colors
                                                                          .green,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                              Icons.done,
                                                                              color: Colors.white),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Text(
                                                                              'Returned',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontFamily: 'Sofia', color: Colors.white)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0),
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      SlideAction(
                                                                    onTap: () {
                                                                      generateFine(snapshot
                                                                          .data
                                                                          .docs[index]);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      color: Colors
                                                                          .red,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                              Icons.error,
                                                                              color: Colors.white),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Text(
                                                                              'Generate Fine',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontFamily: 'Sofia', color: Colors.white)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                        ],
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 0, 10),
                                                      // ignore: deprecated_member_use
                                                      child: FlatButton(
                                                        onPressed: () {},
                                                        minWidth: 110,
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .redAccent
                                                                  .withOpacity(
                                                                      0.4)),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      'Book Name:',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Sofia',
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]['name'],
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Divider(
                                                                  thickness: 1,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      'Issued To:',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]['issued'],
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Divider(
                                                                  thickness: 1,
                                                                ),
                                                                // SizedBox(height: 15),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'Issued On:',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            40),
                                                                    Text(
                                                                      snapshot
                                                                              .data
                                                                              .docs[index][
                                                                                  'issued_on']
                                                                              .toDate()
                                                                              .day
                                                                              .toString() +
                                                                          '-' +
                                                                          snapshot
                                                                              .data
                                                                              .docs[index][
                                                                                  'issued_on']
                                                                              .toDate()
                                                                              .month
                                                                              .toString() +
                                                                          '-' +
                                                                          snapshot
                                                                              .data
                                                                              .docs[index]['issued_on']
                                                                              .toDate()
                                                                              .year
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Divider(
                                                                  thickness: 1,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'Return On:',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            40),
                                                                    Text(
                                                                      snapshot
                                                                              .data
                                                                              .docs[index][
                                                                                  'return_on']
                                                                              .toDate()
                                                                              .day
                                                                              .toString() +
                                                                          '-' +
                                                                          snapshot
                                                                              .data
                                                                              .docs[index][
                                                                                  'return_on']
                                                                              .toDate()
                                                                              .month
                                                                              .toString() +
                                                                          '-' +
                                                                          snapshot
                                                                              .data
                                                                              .docs[index]['return_on']
                                                                              .toDate()
                                                                              .year
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Divider(
                                                                  thickness: 1,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      snapshot.data.docs[index].data().containsKey('fine') &&
                                                                              snapshot.data.docs[index]['fine'] != null
                                                                          ? 'Fine generated: ${snapshot.data.docs[index]['fine'].toString()}'
                                                                          : 'Book return due. Generate fine',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Sofia',
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              : Container();
                                }),
                          ),
                        ],
                      );
              }),
        ),
      ),
    );
  }

  returnedBook(String docId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ReturnedBook(docId: docId);
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

  payFine(DocumentSnapshot book) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PayFine(
            books: book,
          );
        });
  }
}
