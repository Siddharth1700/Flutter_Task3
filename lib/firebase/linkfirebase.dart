import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class MyApplication extends StatefulWidget {
  @override
  _MyApplicationState createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var fsconnect = FirebaseFirestore.instance;
    String cmd;
    String cmdoutput;
    String output;
    myget() async {
      var d = await fsconnect.collection("linux").get();
      // print(d.docs[0].data());

      for (var i in d.docs) {
        setState(() {
          output = i.data()['cmdoutput'];
        });
        print(output);
      }
    }

    linuxcmd(cmd) async {
      var url = "http://192.168.43.200/cgi-bin/firebase_app.py?cmd=${cmd}";
      var response = await http.get(url);
      cmdoutput = response.body;
      fsconnect.collection("linux").add({
        'cmd': cmd,
        'cmdoutput': cmdoutput,
      });
      myget();
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Linux App"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type Command',
                ),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  cmd = value;
                },
              ),
              RaisedButton(
                child: Text('Get Output'),
                onPressed: () {
                  linuxcmd(cmd);
                },
              ),
              Container(
                height: 200,
                width: 200,
                color: Colors.red,
                child: Text(
                  output ?? "Output Terminal",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.teal[900],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
