import 'package:flutter_application_1/allimports.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({super.key});
  
  @override
  State<ActivityList> createState() => _ActivityListState();
}
DateTime? _selectedDate;
class _ActivityListState extends State<ActivityList> {
  List<Collection> clist=[];
  List<Practice> plist=[];
  double listSize=0.0;
  //so practices aren't repeated
  int id=0;

  List<bool> checkedItems = [];
  void hey()async
  {
    Response response= await APIHandler().activityList(globalUser.id);
    dynamic ulist=jsonDecode(response.body);
    for(int i=0;i<ulist.length;i++){
      clist.add(Collection.fromMap(ulist[i]));
      plist.add(Practice.fromMap(ulist[i]));
    }
    checkedItems = List<bool>.filled(plist.length, false);
    setState(() {
      
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
        child: Column(
          children:[
            customAppbarMiddleDroop(MediaQuery.of(context).size.width,context: context,text: 'Activity'),
            Container(
              height:clist.length*35,
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
                            });
                          },
                          ),
                        ),
                        title: Text(pc.title),
                        subtitle: Text(ac.eText!+','+ac.uText!+'...'),
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
          const Row(children: [
            SizedBox(width: 10,),
            Text('End activity on',style: TextStyle(fontSize: 20),),
            DateTimePickerforActivityList(),
          ],),  
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: () async {
              if(_selectedDate==null)
              {
                showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Please Select an end date first", context));
                return;
              }
              else if(!checkedItems.contains(true))
              {
                showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Please Select an activity", context));
                return;
              }
              //to assign only one activity
              int trueCount = checkedItems.where((element) => element == true).length;
              if(trueCount>1)
              {
                showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Can assign only one activity at a time.", context));
                return;
              }
              String dt=DateTime.now().toIso8601String();
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
              Appointment a=Appointment(userId: globalUser.id, patientId: p.pid, feedback: "", appointmentDate: dt, nextAppointDate: _selectedDate!.toIso8601String());
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
              List<AppointmenTest> ptest=[];
              PatientAppointment pat=PatientAppointment(appointment: a, appointmentPractices: aplist, appointmentTests: ptest);
              Response r=await APIHandler().assignActivity(pat);
              if(r.statusCode==200)
              {
                showDialog(context: context, builder: (BuildContext context)
                {
                  return AlertDialog(
                    title: Text("Successful"),
                    content: Text('Activity has been added succesfully!'),
                    actions: [
                      TextButton(onPressed: ()
                      {
                        Navigator.of(context).pop();
                      }, 
                      child: const Text('Close'),
                      )
                    ],
                  );
                });
              }
              else if(r.statusCode==409)
              {
                showDialog(context: context, builder: (BuildContext context)
                {
                  return AlertDialog(
                    title: Text("Duplication"),
                    content: Text(r.body),
                    actions: [
                      TextButton(onPressed: ()
                      {
                        Navigator.of(context).pop();
                      }, 
                      child: const Text('Close'),
                      )
                    ],
                  );
                });
              }
              else{
                showDialog(context: context, builder: (BuildContext context)
                {
                  return AlertDialog(
                    title: Text("Problem"),
                    content: Text('We\'ve encountered a problem. Please try again.'),
                    actions: [
                      TextButton(onPressed: ()
                      {
                        Navigator.of(context).pop();
                      }, 
                      child: const Text('Close'),
                      )
                    ],
                  );
                });
              }
            }, child: Text("Assign")),
            
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

class DateTimePickerforActivityList extends StatefulWidget {
  const DateTimePickerforActivityList({super.key});

  @override
  State<DateTimePickerforActivityList> createState() => _DateTimePickerforActivityListState();
}

class _DateTimePickerforActivityListState extends State<DateTimePickerforActivityList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.calendar_today,color: Color.fromARGB(255, 120, 84, 181),),
          onPressed: () async {
             final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1980),
              lastDate: DateTime(2025),
              
            );
             setState(() {
                _selectedDate = pickedDate;
            });
             
          },
        ),
        Text(
            _selectedDate != null
                ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                : 'No date selected',
            style: const TextStyle(fontSize: 15),
          ),
      ],
    );
  }
}