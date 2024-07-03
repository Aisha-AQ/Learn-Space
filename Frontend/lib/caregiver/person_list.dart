import 'package:flutter_application_1/allimports.dart';

class PersonsList extends StatefulWidget {
  const PersonsList({super.key});

  @override
  State<PersonsList> createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  List<Person> personsList=[];
  late Future<List<Person>> futurePersonsList;
  List<Color> colors=[const Color(0xFFF0B2BD),const Color(0xFFFBD38E)];
  int i=1;
  List<bool> checkedItems = [];
  List<String> relationDropDown=['All'];
  String relationChoice='All';
  List<Person> storageList=[];
  double? heights=0;
  bool isFinished=false;

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
            customAppbarLeftDroop(MediaQuery.of(context).size.width,"Person",45,onPressed: ()
            {
              Navigator.of(context).pop();
            }),

            //const SizedBox(height: 15,),
            //Dropdown
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 60,top: 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), // Adjust the value for roundness
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
                }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
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
                                  offset: const Offset(0, 2),
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
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: IconButton(onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NewPerson()),
                  );
                }, icon: const Icon(Icons.add,size: 50,color: Color(0xFF9474cc),)),
              )),
            const SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}