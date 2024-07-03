
import 'package:flutter_application_1/patient/test.dart';
class TestPerformPatient{
 int? testCollectionID,collectId,opt1,opt2,opt3;
 String? img,audio,etext,opt1eText,op2eText,opt3eText,opt1image,opt1audio,opt2audio,opt3audio,opt2image,opt3image,question;
  TestPerformPatient({required this.testCollectionID,required this.collectId,required this.opt1,required this.opt2,
  required this.opt3,required this.img,required this.audio,required this.etext,required this.opt1eText,
  required this.op2eText,required this.opt3eText,required this.opt1image,required this.opt1audio,required this.opt2audio,
  required this.question,required this.opt2image,required this.opt3audio,required this.opt3image
  });
  
  TestPerformPatient.fromMap(Map<String,dynamic> map,int testId)
  {
    if(map["TestId"]==testId)
    {
      for(int i=0;i<map["Collections"].length;i++)
      {
       TestPerformPatient tpp=TestPerformPatient(
          testCollectionID:map["Collections"][i]["testCollectionID"],
          collectId:map["Collections"][i]["CollectId"],
          opt1 : map["Collections"][i]["Opt1"],
          opt2 : map["Collections"][i]["Opt2"],
          opt3 : map["Collections"][i]["Opt3"],
          img : map["Collections"][i]["Path"],
          audio : map["Collections"][i]["collectAudio"],
          etext : map["Collections"][i]["Etext"],
          opt1eText : map["Collections"][i]["Opt1eText"],
          op2eText : map["Collections"][i]["Opt2eText"],
          opt3eText : map["Collections"][i]["Opt3eText"],
          opt1image : map["Collections"][i]["Op1ImagePath"],
          opt1audio : map["Collections"][i]["Op1Audio"],
          opt2audio : map["Collections"][i]["Op2Audio"],
          opt3audio : map["Collections"][i]["Op3Audio"],
          opt2image : map["Collections"][i]["Op2ImagePath"],
          opt3image : map["Collections"][i]["Op3ImagePath"],
          question : map["Collections"][i]["Question"], 
        );
        pttest.testCollectionlist.add(tpp);
        pttest.aptid=map["aptId"];
      }
      
    }
    
 }
}
