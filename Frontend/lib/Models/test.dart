import 'package:flutter_application_1/allimports.dart';

class Test{
 int? id,stage,createdBy,stageIdentify;
 String? title;
  Test({required this.stage,required this.createdBy,required this.title,id=-1});
  Map<String,dynamic> toMap()
  {
    return {
      "id":id,
      "stage":stage,
      "title":title,
      "createBy":createdBy,
      "stageIdentify":stageIdentify
    };
  }
  Test.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    title=map["title"];
    stage=map["stage"];
    createdBy=map["createdBy"];
    //clist=map["clist"];
    stageIdentify=map["stageIdentify"];
 }
 Test.fromTestMap(Map<String,dynamic> map)
  {
    id=map["testId"];
    title=map["title"];
    stage=map["stage"];
    createdBy=map["createdBy"];
    //clist=map["clist"];
    stageIdentify=map["stageIdentify"];
 }
  static Map<String,dynamic> map(Test t){
    return t.toMap();
  }
}