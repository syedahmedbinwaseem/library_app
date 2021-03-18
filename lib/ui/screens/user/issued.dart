import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Issued extends StatefulWidget {
  @override
  _IssuedState createState() => _IssuedState();
}

class _IssuedState extends State<Issued> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issued Books'),
      ),
    );
  }
}
