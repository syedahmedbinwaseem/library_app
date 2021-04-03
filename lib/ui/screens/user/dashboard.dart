import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/utils/colors.dart';

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
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: navyBlue,
        appBar: AppBar(
          title: Text(
            'Available Books',
            style: TextStyle(
              fontFamily: 'Sofia',
              color: Colors.white,
            ),
          ),
          backgroundColor: navyBlue,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              color: navyBlue,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
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
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
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
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(navyBlue),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data.docs[index]['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(keyword.toLowerCase()) ||
                                  snapshot.data.docs[index]['author']
                                      .toString()
                                      .toLowerCase()
                                      .contains(keyword.toLowerCase()))
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.width * 0.3,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    decoration: BoxDecoration(
                                      color: pink,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]['name'],
                                            style: TextStyle(
                                                fontFamily: 'Sofia',
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'By ' +
                                                snapshot.data.docs[index]
                                                    ['author'],
                                            style: TextStyle(
                                                fontFamily: 'Sofia',
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              else
                                return Container();
                            },
                          );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
