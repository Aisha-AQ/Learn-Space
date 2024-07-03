import 'package:flutter_application_1/allimports.dart';

class AppointmenTest{
  late int id,appointmentId,testId;

  AppointmenTest({required this.appointmentId,required this.testId,this.id=-1});

  AppointmenTest.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    appointmentId=map["appointmentId"];
    testId=map["testId"];
  }
  Map<String,dynamic> toMap()
  {
    return{
      "id":id,
      "appointmentId":appointmentId,
      "testId":testId,

    };
  }
  static List<Map<String,dynamic>> generateMap(List<AppointmenTest> atlist){
    List<Map<String,dynamic>> col_maps=[];
    for(int i=0;i<atlist.length;i++){
      col_maps.add(atlist[i].toMap());
    }
    return col_maps;

  }
}