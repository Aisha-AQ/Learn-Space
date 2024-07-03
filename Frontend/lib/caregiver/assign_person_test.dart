import 'package:flutter_application_1/allimports.dart';

class AssignPersonTest extends StatefulWidget {
  const AssignPersonTest({super.key});
  
  @override
  State<AssignPersonTest> createState() => _AssignPersonTestState();
}

DateTime? _selectedDate;

class _AssignPersonTestState extends State<AssignPersonTest> {
  List<Person> colList = [];
  List<PersonTests> tlist = [];
  List<dynamic> test=[];
  double listSize = 0.0;
  //so practices aren't repeated
  int id = 0;

  List<bool> checkedItems = [];
  void hey() async {
    Response response = await APIHandler().personTestList(globalUser.id);
    dynamic ulist = jsonDecode(response.body);
    if(response==409){return;}
    for (int i = 0; i < ulist.length; i++) {
      //colList.add(Person.fromMap(ulist[i]));
      //tlist.add(PersonTests.fromMap(ulist[i]));
      Map<String,dynamic> map=ulist[i];
      var f={
        "title":map["Title"],
        "testId":map["TestId"],
      };
      test.add(f);
    }
    checkedItems = List<bool>.filled(test.length, false);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customAppbarMiddleDroop(MediaQuery.of(context).size.width,
              context: context, text: 'Test'),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height:  300,
                    child: ListView.builder(
                      itemCount: test.length,
                      itemBuilder: (context, index) {
                        var pc=test[index];
                        if (id != pc["testId"]) {
                          id = pc["testId"];
                          return GestureDetector(
                            child: Card(
                              child: ListTile(
                                //tileColor:pc.assignedFlag!=0? Color.fromARGB(255, 234, 226, 226):Colors.amber,
                                leading: SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: checkedItems[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        checkedItems[index] = value!;
                                      });
                                    },
                                  ),
                                ),
                                title: Text(pc["title"]!),
                                
                                trailing: Text('>'),
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (context) => ActivityCreation(a:colList,p:pc)),
                                  // ); 
                                },
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                   Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'End Test on',
                        style: TextStyle(fontSize: 20),
                      ),
                      DateTimePickerforAssignPersonTest(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            
                            if (_selectedDate == null) {
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
                                          "Please Select at least one Test",
                                          context));
                              return;
                            }
                            int trueCount = checkedItems.where((element) => element == true).length;
                            if(trueCount>1)
                            {
                              showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Can assign only one test at a time.", context));
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
                                    _selectedDate!.toIso8601String());
                            List<AppointmenPersonTest> atlist = [];
                            for (int i = 0; i < checkedItems.length; i++) {
                              if (checkedItems[i] == true) {
                                AppointmenPersonTest ap=AppointmenPersonTest(appointmentId: -1, testId: -1);
                                ap.testId =  test[i]["testId"];
                                atlist.add(ap);
                              }
                            }
                            List<AppointmenPersonPractice> aPrac = [];
                            PersonAppointment pat = PersonAppointment(
                                appointment: a,
                                AppoointmentPersonPractice: aPrac,
                                AppoointmentPersonTest: atlist);
                            Response r =
                                await APIHandler().assignActivity(pat);
                            if (r.statusCode == 200) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Successful"),
                                      content: const Text(
                                          'Test has been assigned succesfully!'),
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PersonTest(
                                showTitleTextBox: true,
                              ),
                            ));
                          },
                          icon: const Icon(Icons.add))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimePickerforAssignPersonTest extends StatefulWidget {
  const DateTimePickerforAssignPersonTest({super.key});

  @override
  State<DateTimePickerforAssignPersonTest> createState() =>
      _DateTimePickerforAssignPersonTestState();
}

class _DateTimePickerforAssignPersonTestState extends State<DateTimePickerforAssignPersonTest> {
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
