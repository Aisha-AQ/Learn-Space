class PersonPractices{
late int? id,patientId,createdBy;
  late String title;
  PersonPractices({required this.patientId,required this.createdBy,required this.title,id=-1});
  Map<String,dynamic> toMap()
  {
    return {
      "id":id,
      "title":title,
      "createBy":createdBy,
      "patientId":patientId
    };
  }
  PersonPractices.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    title=map["title"];
    patientId=map["patientId"];
    createdBy=map["createBy"];
 }
  
}