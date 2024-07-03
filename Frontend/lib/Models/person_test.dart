class PersonTests{
late int id,patientId,createdBy;
  late String title;
  PersonTests({required this.patientId,required this.createdBy,required this.title,required this.id});
  Map<String,dynamic> toMap()
  {
    return {
      "id":id,
      "title":title,
      "createdBy":createdBy,
      "patientId":patientId
    };
  }
  PersonTests.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    title=map["title"];
    patientId=map["patientId"];
    createdBy=map["createdBy"];
 }
static Map<String,dynamic> map(PersonTests t){
  return t.toMap();
}
}