import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/user/drawer.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
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
        FocusScope.of(context).requestFocus();
        FocusScope.of(context).nextFocus();
      },
      child: Scaffold(
        drawer: DrawerApp(),
        appBar: AppBar(
          title: Text(
            'Availavle Books',
            style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
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
                                        return Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          // ignore: deprecated_member_use
                                          child: FlatButton(
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus();
                                              FocusScope.of(context)
                                                  .nextFocus();
                                            },
                                            minWidth: 110,
                                            padding: EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
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
                                                        fontWeight:
                                                            FontWeight.normal),
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
}
