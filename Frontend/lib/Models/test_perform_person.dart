
import 'package:flutter_application_1/patient/test.dart';
class TestPerformPerson{
 int? testCollectionID,AppointmentId,collectId,opt1,opt2,opt3,assigningUserId;
 String? img,audio,name,opt1image,opt1audio,opt2audio,opt3audio,opt2image,opt3image,question;
  TestPerformPerson({required this.testCollectionID,required this.collectId,required this.opt1,required this.opt2,
  required this.opt3,required this.img,required this.audio,required this.name,required this.opt1image,required this.opt1audio,required this.opt2audio,
  required this.question,required this.AppointmentId,required this.opt2image,required this.opt3audio,required this.opt3image
  });
  
  TestPerformPerson.fromMap(Map<String,dynamic> map)
  {
    testCollectionID=map["testCollectionID"];
    AppointmentId=map["AppointmentId"];
    collectId=map["CollectId"];
    img=map["Path"];
    name=map["Name"];
    audio=map["collectAudio"];
    opt1=map["Opt1"];
    opt2=map["Opt2"];
    opt3=map["Opt3"]; 
    question=map["Question"];
    opt1image=map["Op1ImagePath"];
    opt2image=map["Op2ImagePath"];
    opt3image=map["Op3ImagePath"];
    opt1audio=map["Op1Audio"];
    opt2audio=map["Op2Audio"];
    opt3audio=map["Op3Audio"];
    assigningUserId=map["AssigningUserId"];
  }
}
