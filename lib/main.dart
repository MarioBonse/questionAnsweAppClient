import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'formQuestion.dart';
import 'dart:async';
import 'dart:convert';
import 'showResult.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:substring_highlight/substring_highlight.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Domain Q&A',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Open Domain Q&A'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  static const String ServerURL = "http://127.0.0.1:5000/answer"; //
  bool load = false;
  Future<Answer> answer;
  TextEditingController inputtextField = TextEditingController();
  String question;
  String answer_text = '';
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                // Input Bar
                controller: inputtextField,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: _process2, // Bottone
                      icon: Icon(Icons.search),
                    ),
                    suffixText: 'ask',
                    border: OutlineInputBorder(),
                    labelText: 'What do you want to know?'),
              ),
            ),
            Divider(
              height: 50,
              thickness: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder<Answer>(
                future: answer,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //text, str_long, end_long, str_short, end_short
                    return card(
                        question,
                        snapshot.data.answer_long,
                        snapshot.data.answer_short,
                        snapshot.data.start_long,
                        snapshot.data.end_long,
                        snapshot.data.start_short,
                        snapshot.data.end_short);
                  } else if (snapshot.hasError) {
                    return card(question, snapshot.error.toString(), '', '-1',
                        '-1', '-1', '-1');
                  }
                  return card(question, '', '', '-1', '-1', '-1', '-1');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Container card(question, text_long, text_short, str_long, end_long, str_short,
      end_short) {
    SubstringHighlight subH;
    if (text_short != '') {
      subH = SubstringHighlight(
        text: text_long,
        // each string needing highlighting
        term: text_short,
        // user typed "m4a"
        textStyle: TextStyle(fontSize: 21.0, color: Colors.white),
        // non-highlight style
        textStyleHighlight: TextStyle( // highlight style
            fontSize: 24.0,
            color: Colors.amber,
            fontWeight: FontWeight.bold
        ),
      );
    } else {
      subH = SubstringHighlight(
        text: text_long,
        // each string needing highlighting
        term: text_short,
        // user typed "m4a"
        textStyle: TextStyle(fontSize: 21.0, color: Colors.white),
        // non-highlight style
        textStyleHighlight: TextStyle(
            fontSize: 21.0, color: Colors.white), // non-highlight style
      );
    }
    return Container(
        child: Column(
            children: <Widget>[
              SizedBox(
                  width: double.infinity,
                  child:
                  Card(
                      color: Colors.white70,
                      child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                              text: question,
                            ),

                          )
                      )
                  )
              ),
              SizedBox(
                  width: double.infinity,
                  child:
                  Card(
                      color: Colors.blue,
                      child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: RichText(
                            text: TextSpan(

                                style: TextStyle(
                                    fontSize: 21.0, color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(text: 'Long token start: ',
                                      style: TextStyle(color: Colors.amber)),
                                  TextSpan(text: str_long.toString(),
                                      style: TextStyle(color: Colors.white)),
                                  TextSpan(text: '    end: ',
                                      style: TextStyle(color: Colors.amber)),
                                  TextSpan(text: end_long.toString(),
                                      style: TextStyle(color: Colors.white)),
                                  TextSpan(text: '    Short token start: ',
                                      style: TextStyle(color: Colors.amber)),
                                  TextSpan(text: str_short.toString(),
                                      style: TextStyle(color: Colors.white)),
                                  TextSpan(text: '    end: ',
                                      style: TextStyle(color: Colors.amber)),
                                  TextSpan(text: end_short.toString(),
                                      style: TextStyle(color: Colors.white)),
                                ]
                            ),

                          )
                      )
                  )
              ),
              SizedBox(
                  width: double.infinity,
                  child:
                  Card(
                      color: Colors.blue,
                      child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: subH
                      )
                  )
              ),
            ]));
  }

  http.Client _getClient() {
    return http.Client();
  }

  void _process2() {
    if (inputtextField.text.length > 0) {
      setState(() {
        answer = fetchAnswer();
      });
    }
  }

  Future<Answer> fetchAnswer() async {
    await pr.show();
    var client = _getClient();
    question = inputtextField.text;
    final http.Response response = await client.post(
        ServerURL,
        body: {'query': inputtextField.text}
    );
    await pr.hide();
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Ricevuto e ora chiudo");
      client.close();
      inputtextField.clear();
      load = false;
      return Answer.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("closing");
      client.close();
      inputtextField.clear();
      load = false;

      throw Exception('Failed to load Answer');
    }
  }
}

class Answer {
  final String answer_long;
  final String answer_short;
  final int start_short;
  final int end_short;
  final int start_long;
  final int end_long;

  Answer({this.answer_long,
    this.answer_short,
    this.start_short,
    this.end_short,
    this.start_long,
    this.end_long});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answer_long: json['answer_long'],
      answer_short: json['answer_short'],
      start_short: json['start_short'],
      end_short: json['end_short'],
      start_long: json['start_long'],
      end_long: json['end_long'],
    );
  }
}
