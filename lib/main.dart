import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestUrl = "https://api.hgbrasil.com/finance?format=json-cors&key=d37d9bab";

void main() async {

  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Currency Converter"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapShot){
          switch(snapShot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Loading ...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,                    
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapShot.hasError) {
                return Center(
                  child: Text(
                    "Error Loading data :(",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,                    
                    ),
                    textAlign: TextAlign.center,
                  ),
                ); 
              } else {
                return Container(
                  color: Colors.green,
                );
              }
          }
        }),
      
    );
  }
}

Future<Map> getData() async{
  http.Response response = await http.get(requestUrl);
  return json.decode(response.body);
}

