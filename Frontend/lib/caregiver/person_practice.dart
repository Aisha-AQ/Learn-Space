import 'package:flutter_application_1/Models/person_practice_collection.dart';
import 'package:flutter_application_1/allimports.dart';

class PersonPractice extends StatefulWidget {
  const PersonPractice({super.key});

  @override
  State<PersonPractice> createState() => _PersonPracticeState();
}

class _PersonPracticeState extends State<PersonPractice> {
  List<Person> personsList=[];
  late Future<List<Person>> futurePersonsList;
  List<Color> colors=[const Color(0xFFF0B2BD),const Color(0xFFFBD38E)];
  int i=1;
  List<bool> checkedItems = [];
  List<String> relationDropDown=['All'];
  String relationChoice='All';
  List<Person> storageList=[];
  double? heights=0;
  int selected=0;
  TextEditingController title=TextEditingController();
  

  Future<List<Person>> loadPerson()async{
    Response response= await APIHandler().allPerson(globalUser.id);
    dynamic ulist=jsonDecode(response.body);
    for(int i=0;i<ulist.length;i++){
      personsList.add(Person.fromMap(ulist[i]));
    }
    checkedItems = List<bool>.filled(personsList.length, false);
    for(var x in personsList)
    {
      relationDropDown.add(x.relation!);
    }
    relationDropDown=relationDropDown.toSet().toList();
    heights=personsList.length*230;
    setState(() {
      
    });
    return personsList;
  }
  List<Person> pe(List<Person> p)
  {
    return p;
  }
  void updateList(String relation)
  {
    if(relationChoice!='All'&&storageList.length<=personsList.length) {
      storageList=personsList;
      
    }else
    {
      heights=personsList.length*230;
      personsList=storageList;
      futurePersonsList=Future<List<Person>>(() => pe(personsList));
    }
    if(relationChoice!='All') {
      heights=personsList.length*250;
      personsList=personsList.where((element) => element.relation==relation).toList();
      futurePersonsList=Future<List<Person>>(() => pe(personsList));
    }
    setState(() {
      
    });
  }
  @override
  void initState() {
    super.initState();
   futurePersonsList=loadPerson(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            customAppbarLeftDroop(MediaQuery.of(context).size.width,"Person",45,onPressed: (){Navigator.of(context).pop();}),
            //Title TextBox
            TextFormField(controller: title,),
            //Dropdown
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 60,top: 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: const Color(0xFF9474cc), width:1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0,right: 8),
                    child: DropdownButton(
                      value: relationChoice,
                      items: relationDropDown.map((e){
                            return DropdownMenuItem<String>(
                              value: e,
                              child: Text(e));
                            
                          }).toList(),
                          onChanged: (String? selected){
                            relationChoice=selected!;
                            updateList(relationChoice);
                          },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox( height: 12),
            //List
            MediaQuery.removePadding(
               context: context,
              removeTop: true,
              removeBottom: true,
              child: FutureBuilder(
              //itemCount: personsList.length,  
              future: futurePersonsList,
              builder: (context,snapshot)
              {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show loading indicator while waiting
                }
                else{
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                          
                    itemCount: snapshot.data!.length,  
                    itemBuilder: (context,index)
                    {
                      Person person=personsList[index];
                      if(i==0){ i=1; }else { i=0; }
                      return Column(
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [  BoxShadow(
                                  color: Colors.grey.withOpacity(0.4  ),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 190,
                            width: 330,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 190,
                                  width: 90,
                                  color: colors[i], 
                                  child:  Padding(
                                    padding:  const EdgeInsets.only(left: 10.0),
                                    child:  CircleAvatar(
                                      radius: 5,
                                      foregroundImage: Image.memory(base64Decode(person.picPath!)).image,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 190,
                                  width: 240,
                                  color: colors[i],
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0,right:24,left: 15),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            height: 10,
                                            width: 10,
                                            child: Checkbox(
                                              value: checkedItems[index],
                                              onChanged: (bool? value) {
                                                List<bool> x=checkedItems.where((e)=>e==true).toList();
                                                if(value!){selected++;}else{selected--;}
                                                setState(() {
                                                  selected;
                                                  checkedItems[index] = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(person.name!,
                                          style: const TextStyle(fontSize: 25,color: Colors.white, fontWeight: FontWeight.w700),textAlign: TextAlign.left,),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(person.gender!,
                                          style: const TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.left,),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Age:${person.age.toString()}',
                                          style: const TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w700),),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(person.relation!,
                                          style: const TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w700),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      );
                    }
                  );
                }
              }),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Column(children: [
                  ElevatedButton(onPressed: () async {
                    List<PersonPracCol> ppcList=[];
                    for(int i=0;i<checkedItems.length;i++)
                    {
                      if(checkedItems[i]==true)
                      {
                        PersonPracCol ppc=PersonPracCol(personId: -1, PersonPractice: -1);
                        ppc.personId=personsList[i].id;
                        ppcList.add(ppc);
                      }
                    }
                    var practiceInfo = {
                      'patientId': 1,
                      'createdBy': globalUser.id,
                      'title':title.text
                    };
                    var info=
                    {
                      "PersonPractice":practiceInfo,
                      "Persons":ppcList.map((ppc) => ppc.toMap()).toList()
                    };
                    int statusCode= await APIHandler().addCustomPersonPractice(info);
                    if (statusCode == 200) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Successful"),
                                      content: const Text(
                                          'Test has been created succesfully!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        )
                                      ],
                                    );
                                  });
                            } else if (statusCode == 500) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Problem"),
                                      content: Text('We\'ve encountered a problem. \nPlease try again.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        )
                                      ],
                                    );
                                  });
                            }
                  }, child: const Text('Save')),
                  selected==0?const Text(''):Text('$selected selected')
                ],) 
            )),
            const SizedBox(height: 50,),
          ],
          
        ),
      ),
    );
  }
}