
class MessageModel {

  List<Result> result =[];

  MessageModel(this.result);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      (json['result'] as List).map((i) {
        return Result.fromJson(i);
      }).toList(),
    );
  }


}

class Result {


  String sender_name;
  String sender_id;
  String reciver_name;
  String reciver_id;
  String message_text;
  int v;
  String rid;
  String type;


  Result({this.sender_name, this.sender_id, this.reciver_name,
    this.reciver_id, this.message_text, this.v, this.rid, this.type});

  factory Result.fromJson(Map<String, dynamic> parsedJson){

    return Result(
        message_text: parsedJson['message_text'],
        reciver_id: parsedJson['reciver_id'],
        reciver_name: parsedJson['reciver_name'],
        sender_id:  parsedJson['sender_id'],
        sender_name: parsedJson['sender_name'],
        rid : parsedJson['@rid'],
        type : parsedJson ['@class']
    );
  }


}



























/*






class MessageModel{

List<Result> list =[];

MessageModel(this.list);

factory MessageModel.fromJson(Map<String, dynamic> json) {
  return MessageModel(
    (json['result'] as List).map((i) {
      return Result.fromJson(i);
    }).toList(),
  );
}
}


class Result {

  String message_text;
  String reciver_id;
  String reciver_name;
  String sender_id;
  String sender_name;
  String rid;
  String type;

  Result({this.message_text, this.reciver_id, this.reciver_name,
    this.sender_id, this.sender_name, this.rid, this.type});




  factory Result.fromJson(Map<String, dynamic> parsedJson){
    return Result(
        message_text: parsedJson['message_text'],
        reciver_id: parsedJson['reciver_id'],
        reciver_name: parsedJson['reciver_name'],
        sender_id:  parsedJson['sender_id'],
        sender_name: parsedJson['sender_name'],
        rid : parsedJson['@rid'],
        type : parsedJson ['@class']
    );
  }

}*/
