import 'package:flutter/material.dart';
import 'package:flutter_application_1/allimports.dart';

class AssignActivity extends StatefulWidget {
  final bool viewOnly;
  
   AssignActivity({super.key,required this.viewOnly});
  
  @override
  State<AssignActivity> createState() => _AssignActivityState();
}
class _AssignActivityState extends State<AssignActivity> {
  List<Collection> clist=[];
  List<Practice> plist=[];
  double listSize=0.0;
  //so practices aren't repeated
  int id=0;

  List<bool> checkedItems = [];
  late Response response;
  bool _isLoading = false;
  void hey()async
  {
    setState(() {
        _isLoading = true;
    });
    response= await APIHandler().activityList(globalUser.id);
    if(response.statusCode==200)
    {
      dynamic ulist=jsonDecode(response.body);
      for(int i=0;i<ulist.length;i++){
        clist.add(Collection.fromMap(ulist[i]));
        plist.add(Practice.fromMap(ulist[i]));
      }
      checkedItems = List<bool>.filled(plist.length, false);
        setState(() {});
    }
    setState(() {
        _isLoading=false;
      });
   
  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    hey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _isLoading ? SafeArea(child: Center(child: CircularProgressIndicator())) :
        response.statusCode==404?
        SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.40,),
              ElevatedButton(onPressed: ()
              {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateActivity()),
                );
              },child: const Text('Add activity'),)
              
            ],
          ),
        )
        :
        Column(
          //mainAxisSize: MainAxisSize.min,
          children:[
            customAppbarMiddleDroop(MediaQuery.of(context).size.width,context: context,text: 'Activity'),
            Container(
              height:clist.length*60,
              child: ListView.builder(
                itemCount: clist.length,
                itemBuilder: (context, index) 
                {
                  Collection ac=clist[index];
                  Practice pc=plist[index];
                  if(id!=pc.id){
                    id=pc.id!;
                    return GestureDetector(
                    child: Card(
                      child: ListTile(
                        tileColor:pc.assignedFlag!=0? Color.fromARGB(255, 234, 226, 226):Colors.amber,
                        leading: SizedBox(
                          width: 20,
                          child: Checkbox(value: checkedItems[index], onChanged: (bool? value)
                          {
                            setState(() {
                                checkedItems[index] = value!;
                                id=0;
                            });
                          },
                          ),
                        ),
                        title: Text(pc.title),
                        subtitle: Text('${ac.eText!},${ac.uText!}...'),
                        trailing: Text('>'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ActivityCreation(a:clist,p:pc)),
                          );
                          
                        },
                      ),
                    ),
                  );
                  }else{return Container();}
                  
                },
              ),
            ),
          if(response.statusCode==404)
          SizedBox(height: 20,),
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(widget.viewOnly ? const Color.fromARGB(255, 159, 171, 192) : const Color(0xFF9474cc),)),
              onPressed: () async {
              if(widget.viewOnly)
              {
                return;
              }
              //to assign only one activity
              int trueCount = checkedItems.where((element) => element == true).length;
              if(trueCount>1)
              {
                showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Can assign only one activity at a time.", context));
                return;
              }
              List<AppointmentPractice> aplist=[];
              for(int i=0;i<checkedItems.length;i++)
              {
                if(checkedItems[i]==true)
                {
                  AppointmentPractice ap=AppointmentPractice(appointmentId: -1, practiceId: -1);
                  ap.practiceId=plist[i].id!;
                  aplist.add(ap);
                }
              }
              globalAppointmentPractice=aplist;
              showDialog(context: context, builder: (BuildContext context)=> warningDialog("Alert", "Logged into appointment successfully.", context));
              
            }, child: const Text("Add To Appointment",
            style: TextStyle(
              color:Colors.white  // Conditional color
            ),)),
            
            IconButton(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateActivity()),
              );

            },icon:Icon( Icons.add))
          ]),
          ]
        ),
      ),
    );
  }
}
