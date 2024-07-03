import 'package:flutter/material.dart';
import 'package:flutter_application_1/allimports.dart'; // Ensure this import path is correct

class AssignTest extends StatefulWidget {
  final bool viewOnly;
  AssignTest({super.key, required this.viewOnly});

  @override
  State<AssignTest> createState() => _AssignTestState();
}

DateTime? _selectedDate;

class _AssignTestState extends State<AssignTest> {
  List<Collection> colList = [];
  List<Test> tlist = [];
  double listSize = 0.0;
  //so practices aren't repeated
  int id = 0;

  List<bool> checkedItems = [];

  void hey() async {
    Response response = await APIHandler().testList(globalUser.id);
    dynamic ulist = jsonDecode(response.body);
    if(response.statusCode==409){return;}
    for (int i = 0; i < ulist.length; i++) {
      colList.add(Collection.fromMap(ulist[i]));
      tlist.add(Test.fromMap(ulist[i]));
    }
    checkedItems = List<bool>.filled(tlist.length, false);
    setState(() {});
  }

  late bool viewOnly;

  @override
  void initState() {
    super.initState();
    hey();
    viewOnly = widget.viewOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            customAppbarMiddleDroop(MediaQuery.of(context).size.width, context: context),
            Container(
              height: colList.length * 110,
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
                          subtitle: Text(ac.eText! + ',' + ac.uText! + '...'),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      widget.viewOnly ? const Color.fromARGB(255, 159, 171, 192) : const Color(0xFF9474cc),
                    ),
                  ),
                  onPressed: () async {
                    if (widget.viewOnly) {
                      return;
                    }
                    //to assign only one activity
                    int trueCount = checkedItems.where((element) => element == true).length;
                    if(trueCount>1)
                    {
                      showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Can assign only one test at a time.", context));
                      return;
                    }
                    List<AppointmenTest> aplist = [];
                    for (int i = 0; i < checkedItems.length; i++) {
                      if (checkedItems[i] == true) {
                        AppointmenTest ap = AppointmenTest(appointmentId: -1, testId: -1);
                        ap.testId = tlist[i].id!;
                        aplist.add(ap);
                      }
                    }
                    globalAppointmentTest = aplist;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Alert"),
                          content: const Text('Logged into appointment successfully.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "Add To Appointment",
                    style: TextStyle(
                      color: widget.viewOnly ?  Color.fromARGB(255, 185, 81, 203):Colors.white , // Conditional color
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddTest(showTitleTextBox: true),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
