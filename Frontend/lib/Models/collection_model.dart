
import 'package:flutter_application_1/Models/patient_practice.dart';
import 'package:flutter_application_1/allimports.dart';

class Collection{
  late int id;
  late String? uText,eText,type,picPath,C_group,audioPath;
  Collection({required this.uText,required this.eText,required this.type,required this.picPath,required this.C_group,required this.audioPath,id=-1});
  Map<String,dynamic> toMap()
  {
    return {
      "id":id,
      "uText":uText,
      "eText":eText,
      "type":type,
      "picPath":picPath,
      "C_group":C_group,
      "audioPath":audioPath
    };
  }
  Collection.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    uText=map["uText"];
    eText=map["eText"];
    type=map["type"];
    picPath=map["picPath"];
    C_group=map["C_group"];
    audioPath=map["audioPath"];
 }
  int index=0;
  PatientPractice pp = PatientPractice(collectionlist: [], pid: -1,title: ""); 
  Collection.fromMapPatient(Map<String, dynamic> map) {
    for (int i = 0; i < map["Collections"].length; i++) {
      Collection collection = Collection(
        id: map["Collections"][i]["id"],
        uText: map["Collections"][i]["uText"],
        eText: map["Collections"][i]["eText"],
        type: map["Collections"][i]["type"],
        picPath: map["Collections"][i]["picPath"],
        C_group: map["Collections"][i]["C_group"],
        audioPath: map["Collections"][i]["audioPath"],
      );
      //collist.add(collection);
      pp.collectionlist.add(collection);
    }
    pp.pid=map["Collections"][0]["pracId"];
    pp.title=map["Collections"][0]["title"];
    patient_practice.add(pp);
  }
  Collection.fromMap1(Map<String,dynamic> map)
  {
    Collection collection = Collection(
        id: map["id"],
        uText: map["uText"],
        eText: map["eText"],
        type: map["type"],
        picPath: map["picPath"],
        C_group: map["C_group"],
        audioPath: map["audioPath"],
        
      );
      if(practiceExists(map["pracId"]))
      {
        
        for (var practice in patient_practice) {
          if (practice.pid == map["pracId"]) {
            practice.collectionlist.add(collection);
            return;
          }
        }
      }
      pp.collectionlist.add(collection);
      pp.pid=map["pracId"];
      pp.title=map["title"];
      patient_practice.add(pp);
 }
 bool practiceExists(int pid) {
    return patient_practice.any((practice) => practice.pid == pid);
  }
}

