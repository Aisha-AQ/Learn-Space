import 'package:flutter_application_1/Models/test.dart';
import 'package:flutter_application_1/allimports.dart';

class TestPersonCollection{
  late PersonTests test;
  late List<PersonIds> persons;

  TestPersonCollection({required this.test,required this.persons});

  TestPersonCollection.fromMap(Map<String,dynamic> map)
  {
    test=map["Test"];
    //collectionsIds=Collection.fromMap(map["collectionsIds"]) as List<Collection>;
  }
  Map<String,dynamic> toMap()
  {
    return{
    "Test":PersonTests.map(test),
    "Persons":PersonIds.generateMap(persons),
    };
  }
}
class PersonIds{
  int op1;
  int op2;
  int op3;
  int personId;
  int personTestId;
  String questionTitle;
  PersonIds({required this.personTestId,required this.op1,required this.op2, required this.op3, required this.personId, required this.questionTitle});
  
  Map<String,dynamic> toMap(){
    return {
      "op1":op1,
      "op2":op2,
      "op3":op3,
      "personId":personId,
      "personTestId":personTestId,
      "questionTitle":questionTitle,
    };
  }
  static List<Map<String,dynamic>> generateMap(List<PersonIds> prlist){
    List<Map<String,dynamic>> col_maps=[];
    for(int i=0;i<prlist.length;i++){
      col_maps.add(prlist[i].toMap());

    }
    return col_maps;

  }
}