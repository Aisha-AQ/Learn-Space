
import 'package:flutter_application_1/allimports.dart';

class CreateActivity extends StatefulWidget {
  const CreateActivity({super.key});

  @override
  State<CreateActivity> createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  TextEditingController name=TextEditingController();
  List<String> collectionDropDown=['Alphabets','Words','Sentences'];
  List<String> stageDropDown=['Stage-I','Stage-II','Stage-III'];
  String stageChoice='Stage-I';
  String choice='Words';
  //for sentence
  Map<String, int> nameCounts={};
  List<String> groups=[];
  String current="";
  int i=1;
  bool turn=false;
  // List to keep track of checked items
  List<bool> checkedItems = [];
  List<Collection> clist=[];
  double? listHeight=0;

  
  void hey(String type,double? height)async
  {
    Response response= await APIHandler().allCollections(type);
    dynamic ulist=jsonDecode(response.body);
    clist=[];
    groups=[];
    for(int i=0;i<ulist.length;i++){
      clist.add(Collection.fromMap(ulist[i]));
    }
      listHeight=clist.length*height!+40;
    
    checkedItems = List<bool>.filled(clist.length, false);
    if(choice=="Sentences")
    {
      i=0;
      nameCounts = clist.fold({}, (Map<String, int> counts, user) {
      counts[user.C_group!] = (counts[user.C_group] ?? 0) + 1;
      return counts;
      });
      for(var key in nameCounts.keys)
      {
        groups.add(key);
      }
    }
    
    setState(() {
      
    });
     
  
  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    hey("w",120);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: Color(0xFF9474cc),
                boxShadow: const [
                  BoxShadow(blurRadius: 40.0)
                ],
                borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                MediaQuery.of(context).size.width, 100.0)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    right: MediaQuery.of(context).size.width*0.85,
                    top: 50,
                    child: IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    },
                     icon: Icon(Icons.keyboard_arrow_left_sharp,size: 40,color: Colors.white60,))
                  )
                ],),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF9474cc), width:1), 
              ),
              child: TextFormField(
                controller: name,
                //style: TextStyle(fontSize: 5.0),
                decoration: const InputDecoration(
                  hintText: 'Enter name of activity',
                  labelText:  'Activity Name',
                  border: OutlineInputBorder(),
                ),
              
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:85.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0), // Adjust the value for roundness
                      border: Border.all(color: Color(0xFF9474cc), width:1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0,right: 6),
                      child: DropdownButton(
                        value: choice,
                        items: collectionDropDown.map((e){
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e));
                              
                            }).toList(),
                            onChanged: (String? selected){
                      
                              choice=selected!;
                                if(selected=='Alphabets'){
                                   hey("a",19);
                                }else if(selected=='Words'){
                                  hey("w",120);
                                }else if(selected=='Sentences'){
                                  hey("s",90);
                                }
                            },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0), // Adjust the value for roundness
                      border: Border.all(color: Color(0xFF9474cc), width:1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:6.0,right: 6),
                      child: DropdownButton(
                        value: stageChoice,
                        items: stageDropDown.map((e){
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e));
                                    
                            }).toList(),
                            onChanged: (String? selected){
                              setState(() {
                              stageChoice=selected!;  
                              });
                              
                            },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: listHeight,
              child: Padding(
                padding: const EdgeInsets.only(left:30.0),
                child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: choice=="Words"?  (clist.length / 2).ceil():clist.length,
                
                itemBuilder: (context, index) {
                  
                  if(choice=='Alphabets')
                  { 
                    if(index!=24&&index!=25){
                      index=index*3;
                    }
                    if(index<24)
                    {
                      return Row(
                      children: [
                        Container(
                          width: 70,
                          child: Row(
                            children:[
                            Checkbox(
                              value: checkedItems[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  checkedItems[index] = value!;
                                });
                              },
                            ),Text(clist[index].eText!),
                            ]
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left:58.0),
                            child: Container(
                          width: 70,
                              child: Row(
                              children:[
                              Checkbox(
                                value: checkedItems[index+1],
                                onChanged: (bool? value) {
                                  setState(() {
                                      checkedItems[index+1] = value!;
                                  });
                                },
                              ),Text(clist[index+1].eText!)
                              ]
                              ),
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left:58.0),
                            child: Container(
                          width: 70,
                              child: Row(
                              children:[
                              Checkbox(
                                value: checkedItems[index+2],
                                onChanged: (bool? value) {
                                  setState(() {
                                      checkedItems[index+2] = value!;
                                  });
                                },
                              ),Text(clist[index+2].eText!)
                              ]
                              ),
                            ),
                        ),
                      ],
                      
                      );
                    
                    }
                    else if(index==24){
                      index=24;
                      return Row(
                      children: [
                        Container(
                          width: 70,
                          child: Row(
                            children:[
                            Column(
                              children: [
                                
                                Checkbox(
                                  value: checkedItems[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkedItems[index] = value!;
                                    });
                                  },
                                ),
                              ],
                            ),Text(clist[index].eText!),
                            ]
                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(left:58.0),
                            child: Container(width: 70,
                              child: Row(
                              children:[
                              Checkbox(
                                value: checkedItems[index+1],
                                onChanged: (bool? value) {
                                  setState(() {
                                      checkedItems[index+1] = value!;
                                  });
                                },
                              ),Text(clist[index+1].eText!)
                              ]
                              ),
                            ),
                        ),
                      ],
                      
                    );
                    }
                  }else if(choice=='Words')
                  {

                    final firstIndex = index * 2;
                    final secondIndex = index * 2 + 1;

                    // Check if the second index exceeds the list length
                    final bool hasSecondItem = secondIndex < clist.length;
                    if(hasSecondItem)
                    {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Image.memory(base64Decode(clist[firstIndex].picPath!)),
                              const SizedBox(width: 30,),
                              Image.memory(base64Decode(clist[secondIndex].picPath!)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                  child: Checkbox(
                                    value: checkedItems[firstIndex],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        checkedItems[firstIndex] = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Container(
                                  width: 60,
                                  child: Text(clist[firstIndex].eText!)),
                                const SizedBox(width: 8,),
                                Padding(
                                  padding: const EdgeInsets.only(left:130.0),
                                  child: SizedBox(
                                    width: 10,
                                    child: Checkbox(
                                      value: checkedItems[secondIndex],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          checkedItems[secondIndex] = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Text(clist[secondIndex].eText!),
                              ],
                            ),
                          ),
                         
                        ],
                      );
                    }else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.memory(base64Decode(clist[firstIndex].picPath!)),
                          Padding(
                            padding: const EdgeInsets.only(left: 35.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                 SizedBox(
                                    width: 10,
                                    child: Checkbox(
                                      value: checkedItems[firstIndex],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          checkedItems[firstIndex] = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8,),
                                  Text(clist[firstIndex].eText!),
                              ],
                              
                            ),
                          ),
                        ],
                      );
                    }
                    
                  }else if(choice=='Sentences')
                  { 
                    
                    if(clist[index].C_group!=current){
                    if(turn)
                    {
                      i=0;
                      turn=false;
                    }
                      current=groups[i];
                      i++;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(clist[index].C_group!.toUpperCase()),
                          Row(
                          children: [
                            SizedBox(
                            width: 10,
                            child: Checkbox(
                              value: checkedItems[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  checkedItems[index] = value!;
                                });
                              },
                            ),
                            ),
                            const SizedBox(width: 12,),
                            Text(clist[index].eText!)
                          ],
                          ),
                        ],
                      );
                    }else
                    {
                      if(i==groups.length)
                    {
                      turn=true;
                      
                    }
                      return Row(
                      children: [
                        
                        SizedBox(
                        width: 10,
                        child: Checkbox(
                          value: checkedItems[index],
                          onChanged: (bool? value) {
                            setState(() {
                              checkedItems[index] = value!;
                            });
                          },
                        ),
                        ),
                        const SizedBox(width: 12,),
                        Text(clist[index].eText!,)
                      ],
                    );
                    }
                  }
                },
              ),
              ),
            ),
            SizedBox(height: 10,),
            customButton(
              'Save',
              ()async{
                bool containsTrue = checkedItems.any((element) => element == true);
              if(name.text==""||!containsTrue)
              {
                showDialog(
                  context: context,
                  builder:(context) => warningDialog("Warning", "Please make sure all the fields are filled.", context));
                return;
              }
              List<Map<String,dynamic>> selectedCollections=[];
              for(int i=0;i<checkedItems.length;i++)
              {
                if(checkedItems[i]==true)
                {
                  selectedCollections.add({"collectid":clist[i].id});
                  
                }
              }int stage=0;
              if(stageChoice=="Stage-I"){stage=1;}else if(stageChoice=="Stage-II"){stage=2;}else{stage=3;}
              var practice = {
                'stage': stage,
                'title': name.text,
                'createBy': globalUser.id,
                'assignedFlag':0
              };
              var PracticeCollection=
              {
                "practice":practice,
                "collections":selectedCollections
              };
              int finished=await  APIHandler().addCustomPractice(PracticeCollection);
              if(finished==200){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Completed'),
                      content: const Text('Data has been added successfully!.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if(globalUser.type=="caregiver")
                            {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const ActivityList()),
                              ); 
                            }else{
                              Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const DocHome()),
                            );
                            }
                             
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              }else{
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('There was a problem saving the data.\nPlease try again.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              }
             
            },
            ),
            
          ],
        
        ),
      ),
    );
  }
}

