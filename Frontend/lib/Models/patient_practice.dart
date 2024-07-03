import 'package:flutter_application_1/Models/collection_model.dart';

class PatientPractice{
  late int pid;
  late String title;
  late List<Collection> collectionlist;
  PatientPractice({required this.pid,required this.title,required this.collectionlist,});    

  // PatientPRactice.fromMap(Map<String,dynamic> map)
  // {
  //   id=map["id"];
  //   name=map["name"];
  //   age=map["age"];
  //   gender=map["gender"];
  //   relation=map["relation"];
  //   picPath=map["picPath"];
  // }


}