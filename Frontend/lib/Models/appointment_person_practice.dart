
class AppointmenPersonPractice{
  late int id,appointmentId,personPracticeId;

  AppointmenPersonPractice({required this.appointmentId,required this.personPracticeId,this.id=-1});

  AppointmenPersonPractice.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    appointmentId=map["appointmentId"];
    personPracticeId=map["personPracticeId"];
  }
  Map<String,dynamic> toMap()
  {
    return{
      "id":id,
      "appointmentId":appointmentId,
      "personPracticeId":personPracticeId,
    };
  }
  static List<Map<String,dynamic>> generateMap(List<AppointmenPersonPractice> aplist){
    List<Map<String,dynamic>> col_maps=[];
    for(int i=0;i<aplist.length;i++){
      col_maps.add(aplist[i].toMap());
    }
    return col_maps;

  }
}