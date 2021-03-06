
class UserModel{

  String Username;
  String rid;
  String type;

  UserModel({this.Username, this.rid, this.type});


  factory UserModel.fromJson(Map<String, dynamic> parsedJson){
    return UserModel(
        Username: parsedJson['username'],
        rid : parsedJson['@rid'],
        type : parsedJson ['@class']
    );
  }


}