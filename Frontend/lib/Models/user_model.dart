class User{
  late int id;
  late String type,name,username,password,profPicPath;
  User({required this.type, required this.name, required this.username,required this.profPicPath,id=-1});
  User.fromMap(Map<String,dynamic> map)
  {
    id=map["uid"];
    name=map["name"];
    type=map["type"];
    username=map["username"];
    password=map["password"];
    profPicPath=map["profPicPath"];
 }
 
}
