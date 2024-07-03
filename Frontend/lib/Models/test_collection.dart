import 'package:flutter_application_1/Models/test.dart';
import 'package:flutter_application_1/allimports.dart';

class TestCollection{
  late Test test;
  late List<CollectionIds> collectionsIds;

  TestCollection({required this.test,required this.collectionsIds});

  TestCollection.fromMap(Map<String,dynamic> map)
  {
    test=map["test"];
    //collectionsIds=Collection.fromMap(map["collectionsIds"]) as List<Collection>;
  }
  Map<String,dynamic> toMap()
  {
    return{
    "test":Test.map(test),
    "collectionsIds":CollectionIds.generateMap(collectionsIds),
    };
  }
}
class CollectionIds{
  int op1;
  int op2;
  int op3;
  int collectid;
  String question;
  CollectionIds({required this.op1,required this.op2, required this.op3, required this.collectid, required this.question});
  
  Map<String,dynamic> toMap(){
    return {
      "op1":op1,
      "op2":op2,
      "op3":op3,
      "collectid":collectid,
      "question":question,
    };
  }
  static List<Map<String,dynamic>> generateMap(List<CollectionIds> clist){
    List<Map<String,dynamic>> col_maps=[];
    for(int i=0;i<clist.length;i++){
      col_maps.add(clist[i].toMap());

    }
    return col_maps;

  }
}