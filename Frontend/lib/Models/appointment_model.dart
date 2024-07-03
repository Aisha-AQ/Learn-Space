import 'package:flutter_application_1/allimports.dart';

class Appointment{
  late int id,userId,patientId;
  late String feedback;
  late String appointmentDate,nextAppointDate; 

  Appointment({required this.userId,required this.patientId,required this.feedback,required this.appointmentDate, required this.nextAppointDate,this.id=-1});

  Appointment.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    userId=map["userId"];
    patientId=map["patientId"];
    feedback=map["feedback"];
    appointmentDate=map["appointmentDate"];
    nextAppointDate=map["nextAppointDate"];
  }
  Map<String,dynamic> toMap()
  {
    return{
      "id":id,
      "userId":userId,
      "patientId":patientId,
      "feedback":feedback,
      "appointmentDate":appointmentDate,
      "nextAppointDate":nextAppointDate,

    };
  }
  static Map<String,dynamic> map(Appointment a){
    return a.toMap();
  }
  static List<Map<String,dynamic>> generateMap(List<Appointment> aplist){
    List<Map<String,dynamic>> col_maps=[];
    for(int i=0;i<aplist.length;i++){
      col_maps.add(aplist[i].toMap());
    }
    return col_maps;

  }
}