import 'package:flutter_application_1/allimports.dart';

class TestListPatient extends StatefulWidget {
  const TestListPatient({super.key});
  
  @override
  State<TestListPatient> createState() => _TestListPatientState();
}
DateTime? _selectedDate;
class _TestListPatientState extends State<TestListPatient> {
  List<Collection> colList=[];
  List<Test> tlist=[];
  double listSize=0.0;
  //so practices aren't repeated
  int id=0;
  bool finished=false;
  List<bool> checkedItems = [];
  void hey()async
  {
    Response response1= await APIHandler().checkCaregiverAgainstPatient(globalPatient.pid);
    dynamic ulist1=jsonDecode(response1.body);
    final now = DateTime.now();
    Response response= await APIHandler().assisgnedTestList(globalPatient.pid,now);
    dynamic ulist=jsonDecode(response.body);
    if(response.statusCode==409)
    {
      
      
    }else{
      for(int i=0;i<ulist.length;i++){
        colList.add(Collection.fromMap(ulist[i]));
        tlist.add(Test.fromMap(ulist[i]));
      }
      ulist=jsonDecode(response.body);
      checkedItems = List<bool>.filled(tlist.length, false);
    }
    //sort based on id\
    tlist.sort((a, b) => a.id!.compareTo(b.id!));
    //response= await APIHandler().assignedTestsIds(ulist1,DateTime.now());
    setState(() {
        finished=true;
      });
  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    finished=false;
    hey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: 
        Column(
          //mainAxisSize: MainAxisSize.min,
          children:[
            customAppbarMiddleDroop(MediaQuery.of(context).size.width,context: context,text: 'Test'),
            Container(
              height:colList.length*200,
              child: finished==false?Center(child: CircularProgressIndicator(),):
              colList.length==0?warningDialog('Warning', 'No tests are currently assigned', context):ListView.builder(
                itemCount: colList.length,
                itemBuilder: (context, index) 
                {
                  Collection ac=colList[index];
                  Test pc=tlist[index];
                  if(id!=pc.id){
                    id=pc.id!;
                    return GestureDetector(
                    child: Card(
                      child: ListTile(
                        //tileColor:pc.assignedFlag!=0? Color.fromARGB(255, 234, 226, 226):Colors.amber,
                        
                        title: Text(pc.title!),
                        subtitle: Text(ac.eText!+','+ac.uText!+'...'),
                        trailing: Text('>'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TestPatient(testid:pc.id!)),
                          );
                          
                        },
                      ),
                    ),
                  );
                  }else{return Container();}
                  
                },
              ),
            ),

          ]
        ),
      ),
    );
  }
}

class DateTimePickerforTestListPatient extends StatefulWidget {
  const DateTimePickerforTestListPatient({super.key});

  @override
  State<DateTimePickerforTestListPatient> createState() => _DateTimePickerforTestListPatientState();
}

class _DateTimePickerforTestListPatientState extends State<DateTimePickerforTestListPatient> {
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