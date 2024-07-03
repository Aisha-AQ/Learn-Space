import 'package:flutter_application_1/allimports.dart';

class TestList extends StatefulWidget {
  const TestList({super.key});
  
  @override
  State<TestList> createState() => _TestListState();
}

DateTime? _selectedDate;

class _TestListState extends State<TestList> {
  List<Collection> colList = [];
  List<Test> tlist = [];
  double listSize = 0.0;
  //so practices aren't repeated
  int id = 0;

  List<bool> checkedItems = [];
  void hey() async {
    Response response = await APIHandler().testList(globalUser.id);
    dynamic ulist = jsonDecode(response.body);
    if(response==409){return;}
    for (int i = 0; i < ulist.length; i++) {
      colList.add(Collection.fromMap(ulist[i]));
      tlist.add(Test.fromMap(ulist[i]));
    }
    checkedItems = List<bool>.filled(tlist.length, false);
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
                    height: 500,
                    child: ListView.builder(
                      itemCount: colList.length,
                      itemBuilder: (context, index) {
                        Collection ac = colList[index];
                        Test pc = tlist[index];
                        if (id != pc.id) {
                          id = pc.id!;
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
                                title: Text(pc.title!),
                                subtitle:
                                    Text(ac.eText! + ',' + ac.uText! + '...'),
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
                      DateTimePickerforTestList(),
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
                            List<AppointmenTest> atlist = [];
                            for (int i = 0; i < checkedItems.length; i++) {
                              if (checkedItems[i] == true) {
                                AppointmenTest ap = AppointmenTest(
                                    appointmentId: -1, testId: -1);
                                ap.testId = tlist[i].id!;
                                atlist.add(ap);
                              }
                            }
                            List<AppointmentPractice> aPrac = [];
                            PatientAppointment pat = PatientAppointment(
                                appointment: a,
                                appointmentPractices: aPrac,
                                appointmentTests: atlist);
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
                              builder: (context) => AddTest(
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

class DateTimePickerforTestList extends StatefulWidget {
  const DateTimePickerforTestList({super.key});

  @override
  State<DateTimePickerforTestList> createState() =>
      _DateTimePickerforTestListState();
}

class _DateTimePickerforTestListState extends State<DateTimePickerforTestList> {
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
