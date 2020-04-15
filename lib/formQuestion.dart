
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nice_button/nice_button.dart';

class FormQuestion extends StatefulWidget {
  @override
  _FormQuestionState createState() => _FormQuestionState();
}

class _FormQuestionState extends State<FormQuestion> {

  static const String ServerURL = "http://10.0.2.2:5000/answer"; //
  static const String ServerURL2 = "http://10.0.2.2:5000/getTest"; //
  final myController = TextEditingController();

  //colors for the botton
  var firstColor = Colors.amber[400], secondColor = Colors.red[300];
  
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


  void _getResponse() async{
      var client = _getClient();
      try{
        print("sending");
        final http.Response response = await client.post(ServerURL,
          body: {'query': myController.text},);
        print("recived somenthig");
        print(response);
        Map<String, dynamic> data = jsonDecode(response.body);
        Navigator.pop(context);
        Navigator.pushNamed(context, "/showresults", arguments: data);
        print(data);
      }catch(e){
        print("Failed -> $e");
      }finally{
        print("closing");
        client.close();
        myController.clear();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.red[100],
          body: SafeArea(
            child: Center(
                    child: Container(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                child: Card(
                                  color: Colors.red[50],
                                  child: TextFormField(
                                  controller: myController,
                                  decoration: InputDecoration(
                                  labelText: 'What do you want to know?'
                                  ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: NiceButton(
                                    radius: 40,
                                    padding: const EdgeInsets.all(15),
                                    text: "Ask to smart bot",
                                    icon: Icons.account_box,
                                    gradientColors: [secondColor, firstColor],
                                    onPressed: () {                       
                                        if(myController.text.length > 0) {
                                          Navigator.pushNamed(context, "/loading");
                                          this._getResponse();
                                        }
                                      },
                                    ),
                              )

                            ],
                          ),
      ),
            ),
          ),
    );
  }
}