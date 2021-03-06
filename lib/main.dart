import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_orientdb_app/List_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TextEditingController username = new TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            new Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: username,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: InputDecoration(
                    hintText: "Username",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            new RaisedButton(
              onPressed:(){

                if(username.text != "" && username.text != null){

                  PostData();

                }
                else{

                  showTost('Username is required');

                }
              } ,
              child: Text('Login'),
              padding: EdgeInsets.all(15.0),
              textColor: Colors.white,
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void PostData() async{

    String db_User='root';

    String db_Password='orientdb';

    var byte = utf8.encode('$db_User:$db_Password');

    var cre = base64.encode(byte);

    var Headers ={

      'Accept-Encoding': 'gzip,deflate',
      'Content-Length': '0',
      'Authorization':'Basic $cre'

    };

    var postDataurl = "http://192.168.1.4:2480/command/chat_db/sql/INSERT INTO tbl_user SET username='"+username.text+"'";

    http.Response response = await http.post(postDataurl,headers: Headers);

    if (response.statusCode == 200) {

      showTost('Login Successfully');

      print('Login Success');
      SharedPreferences prf =
      await SharedPreferences.getInstance();
      prf.setString('name', username.text);
      username.clear();

      Navigator.pushReplacement(context, (MaterialPageRoute(builder: (context)=> List_data())));


    }
    else {
      showTost('Error');
      print('Error');
    }



  }

  showTost(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }
}
