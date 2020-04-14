import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'formQuestion.dart';
import 'showResult.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/":(context) => FormQuestion(),
        "/loading":(context) => LoadingResult(),
        "/showresults":(context) => ShowResult(),
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}



class LoadingResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SpinKitFadingCube(
            color: Colors.red,
            size: 70.0,
          ),
      ),
      
    );
  }
}