import 'package:flutter_application_1/allimports.dart';

class AppointmenPersonTest{
  late int id,appointmentId,testId;

  AppointmenPersonTest({required this.appointmentId,required this.testId,this.id=-1});

  AppointmenPersonTest.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    appointmentId=map["appointmentId"];
    testId=map["personTestId"];
  }
  Map<String,dynamic> toMap()
  {
    return{
      "id":id,
      "appointmentId":appointmentId,
      "personTestId":testId,

    };
  }
  static List<Map<String,dynamic>> generateMap(List<AppointmenPersonTest> atlist){
    List<Map<String,dynamic>> col_maps=[];
    for(int i=0;i<atlist.length;i++){
      col_maps.add(atlist[i].toMap());
    }
    return col_maps;

  }
}