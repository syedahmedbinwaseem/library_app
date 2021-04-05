import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:library_app/ui/screens/admin/Manage%20Users/addUser.dart';
import 'package:library_app/ui/screens/admin/Manage%20Users/deleteUser.dart';
import 'package:library_app/utils/colors.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  TextEditingController searchItems = TextEditingController();
  String keyword = '';

  Stream<QuerySnapshot> stream() {
    return FirebaseFirestore.instance.collection('user').snapshots();
  }

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
    //var hieght = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Users',
            style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
          ),
          backgroundColor: navyBlue,
        ),
        floatingActionButton: addUser(),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
          child: StreamBuilder(
            stream: stream(),
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
                                if (snapshot.data.docs[index]['email']
                                    .toString()
                                    .toLowerCase()
                                    .contains(keyword.toLowerCase()))
                                  return GestureDetector(
                                    onTap: () {
                                      print('as');
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      secondaryActions: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: SlideAction(
                                                onTap: () {
                                                  deleteUser(snapshot
                                                      .data.docs[index].id);
                                                },
                                                child: Container(
                                                  color: Colors.red,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.delete,
                                                          color: Colors.white),
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
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        // ignore: deprecated_member_use
                                        child: FlatButton(
                                          onPressed: () {
                                            print('as');
                                            FocusScope.of(context).unfocus();
                                          },
                                          minWidth: 110,
                                          padding: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: pink,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snapshot.data.docs[index]
                                                        ['name'],
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      fontFamily: 'Sofia',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    snapshot.data.docs[index]
                                                        ['email'],
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                      fontFamily: 'Sofia',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                else
                                  return Container();
                              }),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  addUser() {
    return FloatingActionButton(
      backgroundColor: navyBlue,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AddUser();
            });
      },
      child: Center(
        child: Icon(Icons.add),
      ),
    );
  }

  deleteUser(String docId) {
    showDialog(
        context: context,
        builder: (context) {
          return DeleteUser(
            docId: docId,
          );
        });
  }
}
