class PersonPracCol{
  late int id,personId,PersonPractice; 

  PersonPracCol({required this.personId,required this.PersonPractice,this.id=-1});

  PersonPracCol.fromMap(Map<String,dynamic> map)
  {
    id=map["id"];
    PersonPractice=map["PersonPractice"];
    personId=map["personId"];
  }
  Map<String,dynamic> toMap()
  {
    return{
      "id":id,
      "personId":personId,
      "PersonPractice":PersonPractice,

    };
  }
}