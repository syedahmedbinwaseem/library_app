import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class IssueBook extends StatefulWidget {
  String docId;

  IssueBook({this.docId});
  @override
  _IssueBookState createState() => _IssueBookState();
}

class _IssueBookState extends State<IssueBook> {
  TextEditingController searchItems = TextEditingController();

  String keyword = '';
  bool isLoading = false;
  bool selected = true;

  Map<String, bool> values = {};

  void getData() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('user').get();

    DocumentSnapshot abc = await FirebaseFirestore.instance
        .collection('books')
        .doc(widget.docId)
        .get();

    snap.docs.forEach((element) {
      if (abc['issued'].toString().contains(element['email'])) {
        setState(() {
          values[element['email']] = true;
        });
      } else {
        setState(() {
          values[element['email']] = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    searchItems.addListener(() {
      setState(() {
        keyword = searchItems.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: values.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Issue Book',
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Users:',
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: Center(
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
                          ),
                          SizedBox(height: 10),
                          Flexible(
                              child: Container(
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent.withOpacity(0.2),
                            ),
                            child: ListView(
                              children: values.keys.where((element) {
                                return element.contains(searchItems.text);
                              }).map((String key) {
                                return new CheckboxListTile(
                                  title: new Text(
                                    key,
                                    style: TextStyle(fontFamily: 'Sofia'),
                                  ),
                                  value: values[key],
                                  onChanged: (bool value) {
                                    values.forEach((key, value) {
                                      setState(() {
                                        values[key] = false;
                                      });
                                    });
                                    // values[key] = false;

                                    setState(() {
                                      values[key] = value;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            // child: CheckboxListTile(
                            //   value: ,
                            // ),
                            // child: ListView.builder(
                            //     itemCount:
                            //         snapshot.data.docs.length,
                            //     itemBuilder: (context, index) {
                            //       return Row(
                            //         children: [
                            //           Checkbox(
                            //               value: shot
                            //                       .data['issued']
                            //                       .toString()
                            //                       .contains(snapshot
                            //                                   .data
                            //                                   .docs[
                            //                               index]
                            //                           ['email'])
                            //                   ? selected
                            //                   : false,
                            //               onChanged: (value) {
                            //                 value = !value;
                            //                 print(value);
                            //                 setState(() {
                            //                   selected =
                            //                       !selected;
                            //                 });
                            //               }),
                            //           Text(snapshot.data
                            //               .docs[index]['email'])
                            //         ],
                            //       );
                            //     }),
                          )),
                          SizedBox(height: 0),
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
                                    // name.clear();
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
                                    setState(() {
                                      isLoading = true;
                                    });
                                    String email = '';
                                    FocusScope.of(context).unfocus();
                                    List<String> array = [];
                                    values.forEach((key, value) {
                                      if (value == false) {
                                      } else if (value == true) {
                                        array.add(key);
                                        email = key;
                                      }
                                    });
                                    print(array);
                                    await FirebaseFirestore.instance
                                        .collection('books')
                                        .doc(widget.docId)
                                        .update({
                                      'issued': email,
                                      'issued_on': array.length == 0
                                          ? null
                                          : DateTime.now(),
                                      'return_on': array.length == 0
                                          ? null
                                          : DateTime.now()
                                              .add(Duration(days: 14))
                                    });

                                    // if (fKey.currentState.validate()) {
                                    //   setState(() {
                                    //     isLoading = true;
                                    //   });

                                    // await FirebaseFirestore.instance
                                    //     .collection('books')
                                    //     .doc()
                                    //     .set({
                                    //   'name': name.text,
                                    //   'author': author.text,
                                    //   'added_on': Timestamp.now(),
                                    //   'issued': [],
                                    //   'available': available
                                    // });

                                    Navigator.pop(context);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: Text('Save',
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
        ),
      ),
    );
  }
}
