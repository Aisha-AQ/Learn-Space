import 'package:flutter_application_1/allimports.dart';

class AppointmentPractice{
  late int id,appointmentId,practiceId;

  AppointmentPractice({required this.appointmentId,required this.practiceId,this.id=-1});

  AppointmentPractice.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    appointmentId=map["appointmentId"];
    practiceId=map["testId"];
  }
  Map<String,dynamic> toMap()
  {
    return{
      "id":id,
      "appointmentId":appointmentId,
      "practiceId":practiceId,
    };
  }
  static List<Map<String,dynamic>> generateMap(List<AppointmentPractice> aplist){
    List<Map<String,dynamic>> col_maps=[];
    for(int i=0;i<aplist.length;i++){
      col_maps.add(aplist[i].toMap());
    }
    return col_maps;

  }
}