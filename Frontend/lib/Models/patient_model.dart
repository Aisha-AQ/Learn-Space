class Patient
{
  late bool firstTime;
  late int pid,age,stage;
  late String gender,name,userName,password,profPicPath;
  Patient({required this.age,required this.password,required this.gender,required this.name,required this.stage,required this.firstTime, required this.userName,required this.profPicPath,pid=-1});
  Patient.fromMap(Map<String,dynamic> map)
  {
    pid=map["pid"];
    age=map["age"];
    firstTime=map["firstTime"];
    userName=map["userName"];
    password=map["password"];
    gender=map["gender"];
    stage=map["stage"];
    name=map["name"];
    profPicPath=map["profPicPath"];
 }
 Patient.fromRequestMap(Map<String,dynamic> map)
  {
    pid=map["pid"];
    stage=map["stage"];
    name=map["name"];
    profPicPath=map["profPicPath"];
 }
 Patient.fromMyPatientsMap(Map<String,dynamic> map)
  {
    pid=map["pid"];
    name=map["name"];
    profPicPath=map["profPicPath"];
 }


}