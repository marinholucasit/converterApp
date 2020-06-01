import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestUrl = "https://api.hgbrasil.com/finance?format=json-cors&key={chaveDaApi}";

void main() async {

  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarControler = TextEditingController();
  final euroController = TextEditingController();
  
  double dolar;
  double euro;

  void _realChanged(String text){
    double real         = double.parse(text);
    dolarControler.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dolar        = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro         = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarControler.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

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
                dolar = snapShot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapShot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      BuildTextField("Real", "R\$", realController, _realChanged),
                      Divider(),
                      BuildTextField("Dolar", "US\$", dolarControler, _dolarChanged),                      
                      Divider(),
                      BuildTextField("Euro", "€", euroController, _euroChanged),                      
                    ],
                  ),
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

Widget BuildTextField(String cLabel, String cPrefix, TextEditingController oController, Function fFunction){
  return TextField( controller: oController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],                    
                    decoration: InputDecoration(
                      labelText: cLabel,
                      labelStyle: TextStyle(color: Colors.amber),
                      border: OutlineInputBorder(),
                      prefixText: cPrefix, 
                    ),
                    style: TextStyle(
                      color: Colors.amber, 
                      fontSize: 25.0,
                    ),
                    onChanged: fFunction,
                  );
}
