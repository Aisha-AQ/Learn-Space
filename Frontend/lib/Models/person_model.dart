class Person{
  late int id,age;
  late String? name,gender,relation,picPath;
  Person({required this.age,id=-1,required this.name, required this.gender,required this.relation,required this.picPath});    

  Person.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    name=map["name"];
    age=map["age"];
    gender=map["gender"];
    relation=map["relation"];
    picPath=map["picPath"];
  }


}