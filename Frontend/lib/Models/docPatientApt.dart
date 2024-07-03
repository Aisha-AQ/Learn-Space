import 'package:flutter_application_1/allimports.dart';

class DocPatientApt{
  late Appointment ap;
  late Patient pat;

  DocPatientApt({required this.pat,required this.ap});

  DocPatientApt.fromMap(Map<String,dynamic> map)
  {
    ap=map["appointment"];
    pat=map["patients"];
  }
  // Map<String,dynamic> toMap()
  // {
  //   return{
  //     "appointment":Appointment.generateMap(ap),
  //     "patients":pat,
  //   };
  // }
  // static List<Map<String,dynamic>> generateMap(List<DocPatientApt> aplist){
  //   List<Map<String,dynamic>> col_maps=[];
  //   for(int i=0;i<aplist.length;i++){
  //     col_maps.add(aplist[i].toMap());
  //   }
  //   return col_maps;

  // }
}