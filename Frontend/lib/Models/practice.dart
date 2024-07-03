class Practice{
late int? id,stage,createdBy,assignedFlag;
  late String title;
  Practice({required this.stage,required this.createdBy,required this.assignedFlag,required this.title,id=-1});
  Map<String,dynamic> toMap()
  {
    return {
      "id":id,
      "stage":stage,
      "title":title,
      "createBy":createdBy,
      "assignedFlag":assignedFlag
    };
  }
  Practice.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    title=map["title"];
    stage=map["stage"];
    createdBy=map["createBy"];
    assignedFlag=map["assignedFlag"];
 }
  
}