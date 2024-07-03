import 'package:flutter_application_1/allimports.dart';


class PersonTest extends StatefulWidget {
  final bool showTitleTextBox;
  const PersonTest({super.key,required this.showTitleTextBox});

  @override
  State<PersonTest> createState() => _PersonTestState();
}
//global variables
TextEditingController title1=TextEditingController(); 
TextEditingController ques1=TextEditingController();
List<Person> radioValue1=[];
List<Person> clist1=[];
List<bool> checkedItems1 = [];
Person? selectedCorrectAnswer1;




class _PersonTestState extends State<PersonTest> {
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

void hey(double? height)async
  {
    globalPersonCollection=[];
    globalPersonTest=null;
    Response response= await APIHandler().allPerson(globalUser.id);
    dynamic ulist=jsonDecode(response.body);
    clist1=[];
    for(int i=0;i<ulist.length;i++){
      clist1.add(Person.fromMap(ulist[i]));
    }
    listHeight=clist1.length*height!;
    checkedItems1 = List<bool>.filled(clist1.length, false);
    ques1.text="";
    setState(() {
      
    });
     
  
  }
void initState()  {
    // TODO: implement initState
    super.initState();
    hey(120);
    
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
                child: customTextFormField(title1, 'Title', 'Title')):Container(),
              SizedBox(height: 10,),
              Container(
                width: 350,
                child: customTextFormField(ques1, 'question', 'Question')
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: listHeight,
                child: Padding(
                padding: const EdgeInsets.only(left:33.0),
                child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount:  (clist1.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final firstIndex = index * 2;
                  final secondIndex = index * 2 + 1;
                  // Check if the second index exceeds the list length
                  final bool hasSecondItem = secondIndex < clist1.length;
                  if(hasSecondItem)
                  {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(base64Decode(clist1[firstIndex].picPath!))),
                            const SizedBox(width: 30,),
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(base64Decode(clist1[secondIndex].picPath!))),
                            //Image.memory(base64Decode(clist1[secondIndex].picPath!)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                                child: Checkbox(
                                  value: checkedItems1[firstIndex],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if(value==true&&checkedItems1.where((element) => element ==true).toList().length==4)
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
                                      else{checkedItems1[firstIndex] = value!;}
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Container(
                                width: 60,
                                child: Text(clist1[firstIndex].name!)),
                              Padding(
                                padding: const EdgeInsets.only(left:130.0),
                                child: SizedBox(
                                  width: 10,
                                  child: Checkbox(
                                    value: checkedItems1[secondIndex],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if(value==true&&checkedItems1.where((element) => element ==true).toList().length==4)
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
                                        checkedItems1[secondIndex] = value!;
                                      }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Text(clist1[secondIndex].name!),
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
                        Image.memory(base64Decode(clist1[firstIndex].picPath!)),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                SizedBox(
                                  width: 10,
                                  child: Checkbox(
                                    value: checkedItems1[firstIndex],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if(checkedItems1.where((element) => element ==true).toList().length==4)
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
                                        checkedItems1[firstIndex] = value!;
                                      }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Text(clist1[firstIndex].name!),
                            ],
                            
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              ),
              ),
            
              SizedBox(height: 5,),
             
              if(checkedItems1.where((element) => element ==true).toList().length==4)
                CorrectAnswer1( showTitleTextBox:widget.showTitleTextBox,scrollController: _scrollController,),
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
class CorrectAnswer1 extends StatefulWidget {
  final bool showTitleTextBox;
  final ScrollController scrollController;
   CorrectAnswer1({required this.showTitleTextBox,required this.scrollController});

  @override
  State<CorrectAnswer1> createState() => _CorrectAnswer1State();
}

class _CorrectAnswer1State extends State<CorrectAnswer1> {
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
      for(int i=0;i<checkedItems1.length;i++)
      {
        if(checkedItems1[i]==true)
        {
          radioValue1.add(clist1[i]);
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
                value: radioValue1[0], 
                groupValue: selectedCorrectAnswer1,
                onChanged: (value)
                {
                  setState(() {
                    selectedCorrectAnswer1 = value;
                  });
                }
              ),SizedBox(
                width: 65,
                child: Text(radioValue1[0].name!)),
              const SizedBox(width: 40,),
              Radio(
                value: radioValue1[1], 
                groupValue: selectedCorrectAnswer1,
                onChanged: (value)
                {
                  setState(() {
                    selectedCorrectAnswer1 = value;
                  });
                }
              ),
              Text(radioValue1[1].name!),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Row(
            children: [
              Radio(
                value: radioValue1[2], 
                groupValue: selectedCorrectAnswer1,
                onChanged: (value)
                {
                  setState(() {
                    selectedCorrectAnswer1 = value;
                  });
                }
              ),SizedBox(
                width: 65,
                child: Text(radioValue1[2].name!)),
              const SizedBox(width: 40,),
              Radio(
                value: radioValue1[3], 
                groupValue: selectedCorrectAnswer1,
                onChanged: (value)
                {
                  setState(() {
                    selectedCorrectAnswer1 = value;
                  });
                }),
                Text(radioValue1[3].name!),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(child:const Text('Finish'), onPressed: () async {
              await addToList1();
              TestPersonCollection tc=TestPersonCollection(test: globalPersonTest!, persons: globalPersonCollection);
              Response code=await APIHandler().uploadPersonTest(tc);
              if(code.statusCode==200){
                showDialog(
                  context: context,
                  builder:(context) => warningDialog("Success", "Test added successfully.", context));
                
                globalPersonCollection=[];
                globalPersonTest=null;
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const CaregiverHomeScreen()));
              }else{
                showDialog(
                  context: context,
                  builder:(context) => warningDialog("Faliure", "There was a problem saving the test..", context));
                
                // globalPersonCollection=[];
                // globalPersonTest=null;
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const CaregiverHomeScreen()));
              }
              @override
              void dispose() {
                widget.scrollController.dispose();
                super.dispose();
              }
            }),
            ElevatedButton(child:const Text('Next'), onPressed: () async {
              if(widget.showTitleTextBox==true&&title1.text=="")
              {
                showDialog(
                  context: context,
                  builder:(context) => warningDialog("Warning", "Please make sure all the fields are filled.", context));
                return;
              }
              await addToList1();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const PersonTest(showTitleTextBox: false,)));
            })
          ],
        ),
        
      ],
    );
    
  }
  Future<void> addToList1() async {
    if(globalTest==null&&widget.showTitleTextBox)
    {
      if(globalPersonTest==null&&widget.showTitleTextBox)
      {
        Response r1=await APIHandler().checkPatientAgainstCaregiver(globalUser.id);
        if(r1.statusCode==500)
        {
          showDialog(
            context: context,
            builder:(context) => warningDialog("Warning", "Register Patient first..", context));
          return;
        }
        dynamic pa=jsonDecode(r1.body);
        Patient p=Patient.fromMap(pa);
        globalPersonTest=PersonTests(id: 1,patientId: p.pid, createdBy: globalUser.id, title: title1.text);
      // globalPersonTest=PersonTests(stage: 1, createdBy: globalUser.id, title: title.text);
      }
    }
    List<int> selectedids=[];
    for(int i=0;i<checkedItems1.length;i++)
    {
      if(checkedItems1[i]==true&&selectedids.length<=4)
      {
        selectedids.add(clist1[i].id);
      }
    }
    selectedids.remove(selectedCorrectAnswer1!.id);
    //CollectionIds cid=CollectionIds(op1: selectedids[0], op2: selectedids[1], op3: selectedids[2], collectid: selectedCorrectAnswer1!.id, question:ques1.text );
    PersonIds prid=PersonIds(personTestId: -1, op1: selectedids[0], op2: selectedids[1], op3: selectedids[2], personId: selectedCorrectAnswer1!.id, questionTitle: ques1.text);
    globalPersonCollection.add(prid);
  }
  
}