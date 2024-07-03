import 'package:flutter_application_1/allimports.dart';


class AddTest extends StatefulWidget {
  final bool showTitleTextBox;
  const AddTest({super.key,required this.showTitleTextBox});

  @override
  State<AddTest> createState() => _AddTestState();
}
//global variables
TextEditingController title=TextEditingController();
TextEditingController ques=TextEditingController();
List<Collection> radioValue=[];
List<Collection> clist=[];
List<bool> checkedItems = [];
Collection? selectedCorrectAnswer;




class _AddTestState extends State<AddTest> {
  ScrollController _scrollController = ScrollController();
  bool firstchoice=false;

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
  //List<Collection> clist=[];
  double? listHeight=0;

void hey(String type,double? height)async
  {
    Response response= await APIHandler().allCollections(type);
    dynamic ulist=jsonDecode(response.body);
    clist=[];
    for(int i=0;i<ulist.length;i++){
      clist.add(Collection.fromMap(ulist[i]));
    }
    listHeight=clist.length*height!;
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
    ques.text="";
    setState(() {
      
    });
     
  
  }
void initState()  {
    // TODO: implement initState
    super.initState();
    hey("w",120);
    
    //items=alphabets;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Test'),),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.showTitleTextBox ? Container(
                width: 350,
                child: customTextFormField(title, 'Title', 'Title')):Container(),
              SizedBox(height: 10,),
              Container(
                width: 350,
                child: customTextFormField(ques, 'question', 'Question')
              ),
              SizedBox(height: 10,),
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
                height: listHeight,
                child: Padding(
                padding: const EdgeInsets.only(left:33.0),
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
                            padding: const EdgeInsets.only(left: 35.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                  child: Checkbox(
                                    value: checkedItems[firstIndex],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if(value==true&&checkedItems.where((element) => element ==true).toList().length==4)
                                        {
                                          showDialog(context: context,
                                           builder: (BuildContext context)
                                           {
                                              return AlertDialog(
                                                title: const Text('Cannot select more than 4 options per question!'),
                                                actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); 
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                              );
                                           });
                                        }
                                        else{checkedItems[firstIndex] = value!;}
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Container(
                                  width: 60,
                                  child: Text(clist[firstIndex].eText!)),
                                Padding(
                                  padding: const EdgeInsets.only(left:130.0),
                                  child: SizedBox(
                                    width: 10,
                                    child: Checkbox(
                                      value: checkedItems[secondIndex],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if(value==true&&checkedItems.where((element) => element ==true).toList().length==4)
                                        {
                                          showDialog(context: context,
                                           builder: (BuildContext context)
                                           {
                                              return AlertDialog(
                                                title: const Text('Cannot select more than 4 options per question!'),
                                                actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); 
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                              );
                                           });
                                        }
                                        else{
                                          checkedItems[secondIndex] = value!;
                                        }
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
                                          if(checkedItems.where((element) => element ==true).toList().length==4)
                                        {
                                          showDialog(context: context,
                                           builder: (BuildContext context)
                                           {
                                              return AlertDialog(
                                                title: const Text('Cannot select more than 4 options per question!'),
                                                actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); 
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                              );
                                           });
                                        }
                                        else{
                                          checkedItems[firstIndex] = value!;
                                        }
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
                        Text(clist[index].eText!)
                      ],
                    );
                    }
                    
                    
                  }
                },
              ),
              ),
              ),
            
              SizedBox(height: 5,),
             
              if(checkedItems.where((element) => element ==true).toList().length==4)
                CorrectAnswer( showTitleTextBox:widget.showTitleTextBox,scrollController: _scrollController,),
            ],
          ),
        ),
      ),
    );  
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
class CorrectAnswer extends StatefulWidget {
  final bool showTitleTextBox;
  final ScrollController scrollController;
   CorrectAnswer({required this.showTitleTextBox,required this.scrollController});

  @override
  State<CorrectAnswer> createState() => _CorrectAnswerState();
}

class _CorrectAnswerState extends State<CorrectAnswer> {
  @override
  Widget build(BuildContext context) {
    
   WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the end after the widget is built
      if(widget.scrollController!=null){
        widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      }
      
    });

    void calculateSelectedAnswers(){
      for(int i=0;i<checkedItems.length;i++)
      {
        if(checkedItems[i]==true)
        {
          radioValue.add(clist[i]);
        }
      }
    };  
    
    if(true){
      calculateSelectedAnswers();
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:  EdgeInsets.only(left: 18.0),
          child:  Text('Choose the correct option:'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Row(
            children: [
              Radio(
                value: radioValue[0], 
                groupValue: selectedCorrectAnswer,
                onChanged: (value)
                {
                  setState(() {
                    selectedCorrectAnswer = value;
                  });
                }
              ),SizedBox(
                width: 65,
                child: Text(radioValue[0].eText!)),
              const SizedBox(width: 40,),
              Radio(
                value: radioValue[1], 
                groupValue: selectedCorrectAnswer,
                onChanged: (value)
                {
                  setState(() {
                    selectedCorrectAnswer = value;
                  });
                }
              ),
              Text(radioValue[1].eText!),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Row(
            children: [
              Radio(
                value: radioValue[2], 
                groupValue: selectedCorrectAnswer,
                onChanged: (value)
                {
                  setState(() {
                    selectedCorrectAnswer = value;
                  });
                }
              ),SizedBox(
                width: 65,
                child: Text(radioValue[2].eText!)),
              const SizedBox(width: 40,),
              Radio(
                value: radioValue[3], 
                groupValue: selectedCorrectAnswer,
                onChanged: (value)
                {
                  setState(() {
                    selectedCorrectAnswer = value;
                  });
                }),
                Text(radioValue[3].eText!),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(child:Text('Finish'), onPressed: () async {
              addToList();
              TestCollection tc=TestCollection(test: globalTest!, collectionsIds: globalCollection);
              Response code=await APIHandler().uploadTest(tc);
              if(code.statusCode==200){
                showDialog(
                  context: context,
                  builder:(context) => warningDialog("Success", "Test added successfully.", context));
                
                globalCollection=[];
                globalTest=null;
              }else{
                showDialog(
                  context: context,
                  builder:(context) => warningDialog("Error", "There was a problem saving this test.", context));
              }
              @override
              void dispose() {
                widget.scrollController.dispose();
                super.dispose();
              }
            }),
            ElevatedButton(child:Text('Next'), onPressed: () {
              if(widget.showTitleTextBox==true&&title.text=="")
              {
                showDialog(
                  context: context,
                  builder:(context) => warningDialog("Warning", "Please make sure all the fields are filled.", context));
                return;
              }
              addToList();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AddTest(showTitleTextBox: false,)));
            })
          ],
        ),
        
      ],
    );
    
  }
  void addToList(){
    if(globalTest==null&&widget.showTitleTextBox)
    {
      globalTest=Test(stage: 1, createdBy: globalUser.id, title: title.text);
    }
    List<int> selectedids=[];
    for(int i=0;i<checkedItems.length;i++)
    {
      if(checkedItems[i]==true&&selectedids.length<=4)
      {
        selectedids.add(clist[i].id);
      }
    }
    selectedids.remove(selectedCorrectAnswer!.id);
    CollectionIds cid=CollectionIds(op1: selectedids[0], op2: selectedids[1], op3: selectedids[2], collectid: selectedCorrectAnswer!.id, question:ques.text );
    globalCollection.add(cid);
  }
  
}