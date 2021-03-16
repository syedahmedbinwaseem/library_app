import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/admin/Books/bookDetails.dart';

class IssuedBooks extends StatefulWidget {
  @override
  _IssuedBooksState createState() => _IssuedBooksState();
}

class _IssuedBooksState extends State<IssuedBooks> {
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
          title: Text('Issued Books'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('books').snapshots(),
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
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return snapshot.data.docs[index]['issued']
                                            .length ==
                                        0
                                    ? Container()
                                    : snapshot.data.docs[index]['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    keyword.toLowerCase()) ||
                                            snapshot.data.docs[index]['author']
                                                .toString()
                                                .toLowerCase()
                                                .contains(keyword.toLowerCase())
                                        ? Padding(
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
                                                height: 100,
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
                                          )
                                        : Container();
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
}
