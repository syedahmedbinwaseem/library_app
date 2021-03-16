import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/ui/screens/admin/Books/addBook.dart';

class AvailableBooks extends StatefulWidget {
  @override
  _AvailableBooksState createState() => _AvailableBooksState();
}

class _AvailableBooksState extends State<AvailableBooks> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Availavle Books'),
      ),
      floatingActionButton: addBooks(),
    );
  }
}
