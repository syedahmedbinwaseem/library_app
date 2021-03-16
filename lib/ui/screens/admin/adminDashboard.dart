import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_app/ui/screens/admin/Books/addBook.dart';
import 'package:library_app/ui/screens/admin/Books/bookDetails.dart';
import 'package:library_app/ui/screens/admin/Books/deleteBook.dart';
import 'package:library_app/ui/screens/admin/Books/editBook.dart';
import 'package:library_app/ui/screens/admin/Books/issuedBooks.dart';
import 'package:library_app/ui/screens/admin/Manage%20Users/users.dart';
import 'package:library_app/ui/screens/login.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  TextEditingController searchItems = TextEditingController();
  String keyword = '';

  @override
  void initState() {
    // TODO: implement initState
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
        FocusScope.of(context).requestFocus();
        FocusScope.of(context).nextFocus();
      },
      child: Scaffold(
        floatingActionButton: addBooks(),
        drawer: Drawer(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                FlatButton(
                  child: Text(
                    'All Books',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Text(
                    'Issued Books',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => IssuedBooks()));
                  },
                ),
                FlatButton(
                  child: Text(
                    'Manage Users',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Users()));
                  },
                ),
                FlatButton(
                  child: Text(
                    'Generate Fines',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 40,
                      child: FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                    builder: (context) => LoginScreen()));
                          }),
                    ),
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text('All Books'),
          // centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // SizedBox(height: 10),
              // Text(
              //   'All Books',
              //   style: TextStyle(fontSize: 30),
              // ),
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('books')
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
                                SizedBox(height: 20),
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
                                                height: 110,
                                                width: 110,
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
                                                height: 110,
                                                width: 110,
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
                                            child: FlatButton(
                                              onPressed: () {
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
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.blueAccent
                                                      .withOpacity(0.4),
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['author'],
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                        'No. of issues: ${snapshot.data.docs[index]['issued'].length}'),
                                                    Expanded(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Text(
                                                              snapshot.data.docs[
                                                                              index]
                                                                          [
                                                                          'available'] ==
                                                                      true
                                                                  ? 'Available'
                                                                  : 'Not Available',
                                                              style: TextStyle(
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
