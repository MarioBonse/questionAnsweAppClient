
import 'package:flutter/material.dart';

class ShowResult extends StatefulWidget {
  @override
  _ShowResultState createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  Map answer = {};
  @override
  Widget build(BuildContext context) {

    answer = ModalRoute.of(context).settings.arguments;

    print(answer);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        ),
      body: Center(
        child: Container(
          child: Text(answer["data"],
          style: TextStyle(fontSize: 30),),
              ),
      ),
      
    );
  }
}