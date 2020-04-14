
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormQuestion extends StatefulWidget {
  @override
  _FormQuestionState createState() => _FormQuestionState();
}

class _FormQuestionState extends State<FormQuestion> {

  static const String ServerURL = "https://supercodebot.herokuapp.com"; //
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  http.Client _getClient(){
    return http.Client();
  }

  void fakerequest() async{
    await Future.delayed(Duration(seconds: 3),(){
      print("ciaio");
    });
    print("showresults");
    Navigator.pop(context);
    Navigator.pushNamed(context, "/showresults", arguments: {
      "data": "ciao",
    });

  }

  void _getResponse() async{
    if (myController.text.length>0){
      var client = _getClient();
      try{
        client.post(ServerURL, body: {"query" : myController.text},)
        ..then((response){
          Map<String, dynamic> data = jsonDecode(response.body);
          Navigator.pop(context);
          Navigator.pushNamed(context, "/showresults", arguments: data);
          print(data);
              });
      }catch(e){
        print("Failed -> $e");
      }finally{
        client.close();
        myController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
                  child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Card(
                                        child: TextFormField(
                                        controller: myController,
                                        decoration: InputDecoration(
                                        labelText: 'What do you want to know?'
                                        ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,30),
                              child: FlatButton(
                              color: Colors.red[800],
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(16.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {
                                
                                this.fakerequest();
                                print(myController.text);
                                myController.clear();
                                Navigator.pushNamed(context, "/loading");
                              },
                              child: Text(
                                "Ask to magic bot", 
                                style: TextStyle(fontSize: 20.0),
                              ),
                              ),
                            )
                          ],
                        ),
      ),
          ),
    );
  }
}