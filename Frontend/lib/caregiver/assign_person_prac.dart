import 'package:flutter_application_1/Models/appointment_person_model.dart';
import 'package:flutter_application_1/Models/appointment_person_practice.dart';
import 'package:flutter_application_1/Models/appointment_person_test.dart';
import 'package:flutter_application_1/allimports.dart';

class AssignPersonPractice extends StatefulWidget {
  const AssignPersonPractice({super.key});

  @override
  State<AssignPersonPractice> createState() => _AssignPersonPracticeState();
}
DateTime? _selectedDate1;
class _AssignPersonPracticeState extends State<AssignPersonPractice> {

  List<PersonPractices> plist=[];
  List<bool> checkedItems = [];
  double listSize=0.0;
  Future<void> loadList()
    async {
      plist=[];
      Response response= await APIHandler().personPractices(globalUser.id);
      dynamic ulist=jsonDecode(response.body);
      for(int t=0;t<ulist.length;t++)
      {
        plist.add(PersonPractices.fromMap(ulist[t]));
      }
      checkedItems = List<bool>.filled(plist.length, false);
      setState(() {
        
      });
    }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadList();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        children: [
          customAppbarMiddleDroop(MediaQuery.of(context).size.width,context: context,text: 'Activity'),
          Container(
            height: plist.length*100,
            child: ListView.builder(
              itemCount: plist.length,
              itemBuilder: (c,index){
                PersonPractices pc=plist[index];
                return GestureDetector(
                    child: Card(
                      child: ListTile(
                        //tileColor:pc.assignedFlag!=0? Color.fromARGB(255, 234, 226, 226):Colors.amber,
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
                       trailing: Text('>'),
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (context) => ActivityCreation(a:clist,p:pc)),
                          // );
                          
                        },
                      ),
                    ),
                  );
              }),
          ),
           Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'End activity on',
                        style: TextStyle(fontSize: 20),
                      ),
                       DateTimePickerforPersonList(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (_selectedDate1 == null) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      warningDialog(
                                          "Warning",
                                          "Please Select an end date first",
                                          context));
                              return;
                            } else if (!checkedItems.contains(true)) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      warningDialog(
                                          "Warning",
                                          "Please Select at least one Activity",
                                          context));
                              return;
                            }
                            int trueCount = checkedItems.where((element) => element == true).length;
                            if(trueCount>1)
                            {
                              showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Can assign only one activity at a time.", context));
                              return;
                            }
                            String dt = DateTime.now().toIso8601String();
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
                            Appointment a = Appointment(
                                userId: globalUser.id,
                                patientId: p.pid,
                                feedback: "",
                                appointmentDate: dt,
                                nextAppointDate:
                                    _selectedDate1!.toIso8601String());
                            List<AppointmenPersonPractice> aplist=[];
                            for(int i=0;i<checkedItems.length;i++)
                            {
                              if(checkedItems[i]==true)
                              {
                                AppointmenPersonPractice ap=AppointmenPersonPractice(appointmentId: -1, personPracticeId: -1);
                                ap.personPracticeId=plist[i].id!;
                                aplist.add(ap);
                              }
                            }
                            List<AppointmenPersonTest> ptest=[];
                            PersonAppointment pat=PersonAppointment(appointment: a, AppoointmentPersonPractice: aplist, AppoointmentPersonTest: ptest);
                            Response r=await APIHandler().assignActivity(pat);
                            if (r.statusCode == 200) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Successful"),
                                      content: const Text(
                                          'Activity has been assigned succesfully!'),
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
                            } else if (r.statusCode == 409) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Duplication"),
                                      content: Text(r.body),
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
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Problem"),
                                      content: const Text(
                                          'We\'ve encountered a problem. Please try again.'),
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
                          },
                          child: const Text("Assign")),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PersonPractice()),);
                          },
                          icon: const Icon(Icons.add))
                    ],
                  ),
        ],
      ),
    );
  }
}
class DateTimePickerforPersonList extends StatefulWidget {
  const DateTimePickerforPersonList({super.key});

  @override
  State<DateTimePickerforPersonList> createState() =>
      _DateTimePickerforPersonListState();
}

class _DateTimePickerforPersonListState extends State<DateTimePickerforPersonList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.calendar_today,
            color: Color.fromARGB(255, 120, 84, 181),
          ),
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1980),
              lastDate: DateTime(2025),
            );
            setState(() {
              _selectedDate1 = pickedDate;
            });
          },
        ),
        Text(
          _selectedDate1 != null
              ? '${_selectedDate1!.year}-${_selectedDate1!.month}-${_selectedDate1!.day}'
              : 'No date selected',
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
