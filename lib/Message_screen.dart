import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_orientdb_app/List_Screen.dart';
import 'package:flutter_orientdb_app/Message_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Message_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new message_screen();
  }
}

class message_screen extends State<Message_screen> {
  bool _isConpomess = false;
  String sender_id = '', sender_name = '', receive_id = '', receive_name = '';

  List<MessageModel> messagedata = new List();
  StreamController _controller;
  SharedPreferences prf;
  TextEditingController chatmessagetext = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new StreamController();
    getPrefData();
  }

  getPrefData() async {
    prf = await SharedPreferences.getInstance();
    sender_id = prf.getString('sender_id');
    sender_name = prf.getString('sender_name');
    receive_id = prf.getString('reciver_id');
    receive_name = prf.getString('reciver_name');

    loadPosts();
  }


  loadPosts() async {
    getItem().then((res) async {
      _controller.add(res);
      return res;
    });
  }


  Future<MessageModel> getItem() async{

    String db_User = 'root';

    String db_Password = 'orientdb';

    var byte = utf8.encode('$db_User:$db_Password');

    var cre = base64.encode(byte);

    var Headers = {
      'Accept-Encoding': 'gzip,deflate',
      'Content-Length': '0',
      'Authorization': 'Basic $cre'
    };

    var postDataurl =
        "http://192.168.1.4:2480/command/chat_db/sql/select from tbl_message/20/*:-1";

    http.Response response = await http.post(postDataurl, headers: Headers);

     var st_code = response.statusCode;

     var res1 = json.decode(response.body);

     return MessageModel.fromJson(res1);


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Chats'),
            leading: GestureDetector(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> List_data()));
              },
            ),
            actions: <Widget>[
              new IconButton(icon: Icon(Icons.refresh), onPressed: () {
                loadPosts();
              })
            ],
          ),
          body: Column(
            children: <Widget>[
              new Flexible(
                  child: StreamBuilder(
                      stream: _controller.stream,
                      builder: (BuildContext con, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) return new Container();

                        return ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            reverse: true,
                            itemCount: snapshot.data.result.length,
                            itemBuilder: (context, index) {
                              bool isOwnMessage = false;
                              if (snapshot.data.result[index].sender_id == sender_id.replaceAll('#', '') && snapshot.data.result[index].reciver_id == receive_id.replaceAll('#', '')) {
                                isOwnMessage = true;

                                return getMessageSendLayout(
                                    snapshot.data.result[index].message_text,
                                    "",
                                    snapshot.data.result[index].sender_name,

                                    snapshot.data.result[index].sender_id,
                                    snapshot.data.result[index].reciver_id);
                              }
                              else if (snapshot.data.result[index].reciver_id == sender_id.replaceAll('#', '') && snapshot.data.result[index].sender_id == receive_id.replaceAll('#', '')) {
                                return getMessageReceiverLayout(
                                    snapshot.data.result[index].message_text,
                                    "",
                                    snapshot.data.result[index].sender_name,

                                    snapshot.data.result[index].sender_id,
                                    snapshot.data.result[index].reciver_id);
                              }

                              return new Container();


                            });
                      })),
              new Divider(
                height: 1.0,
              ),
              new Container(
                child: Text_compond(),
              )
            ],
          ),
        ),
        onWillPop: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> List_data()));
        });
  }

  Widget getMessageSendLayout(String message, String attechment,
      String Sendername, String sender_id, String reciver_id) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          new Expanded(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(
                sender_name,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              new Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: attechment != ""
                      ? new Image.network('')
                      : new Text(message))
            ],
          ))
        ],
      ),
    );
  }

  Widget getMessageReceiverLayout(String message, String attechment,
      String Sendername, String sender_id, String reciver_id) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          new Expanded(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                Sendername,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              new Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: attechment != ""
                      ? new Image.network('')
                      : new Text(message))
            ],
          ))
        ],
      ),
    );
  }

  Widget Text_compond() {
    return new IconTheme(
        data: IconThemeData(
          color: _isConpomess
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              new Flexible(
                  child: new TextField(
                controller: chatmessagetext,
                onChanged: (String messag) {
                  setState(() {
                    _isConpomess = messag.length > 0;
                  });
                },
                onSubmitted: _submited,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              )),
              new Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _isConpomess
                        ? () => _submited(chatmessagetext.text)
                        : null),
              )
            ],
          ),
        ));
  }

  _submited(String message) async {
    String db_User = 'root';

    String db_Password = 'orientdb';

    var byte = utf8.encode('$db_User:$db_Password');

    var cre = base64.encode(byte);

    var Headers = {
      'Accept-Encoding': 'gzip,deflate',
      'Content-Length': '0',
      'Authorization': 'Basic $cre'
    };

    var postMesasage =
        "http://192.168.1.4:2480/command/chat_db/sql/INSERT INTO tbl_message SET message_text ='" +
            chatmessagetext.text +
            "'," +
            "reciver_id='" +
            receive_id.replaceAll("#", '') +
            "'," +
            "reciver_name='" +
            receive_name +
            "'," +
            "sender_id='" +
            sender_id.replaceAll("#", '') +
            "'," +
            "sender_name='" +
            sender_name +
            "'";

    http.Response response = await http.post(postMesasage, headers: Headers);

    if (response.statusCode == 200) {

      chatmessagetext.clear();
      loadPosts();
    } else {
      print("Error");
    }
  }
}
