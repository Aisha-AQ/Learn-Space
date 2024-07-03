import 'dart:math';
import 'package:flutter_application_1/Models/patient_test.dart';
import 'package:flutter_application_1/Models/test_perform_person.dart';
import 'package:flutter_application_1/allimports.dart';

class TestPerson extends StatefulWidget {
  TestPerson({super.key});

  @override
  State<TestPerson> createState() => _TestPersonState();
}

PatientTest pttest = PatientTest(testId: -1, testCollectionlist: [], aptid: -1);

class _TestPersonState extends State<TestPerson> {
  List<int> gvals = [];
  List<orderRadio> order = [];
  bool firstTime = false;
  int orderIndex = -4;

  Future<void> getTestInfo() async {
    //to empty at start in case of leftover data
    pttest = PatientTest(testId: -1, testCollectionlist: [], aptid: -1);
    gvals = [];
    testPerformPerson = [];
    order = [];
    Response r = await APIHandler().personTests(globalPatient.pid);
    dynamic tlist = jsonDecode(r.body);
    for (int i = 0; i < tlist.length; i++) {
      testPerformPerson.add(TestPerformPerson.fromMap(tlist[i]));
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTestInfo();
  }

  String? _filePath;
  AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> saveJsonAsMp3(String jsonString) async {
    _filePath = null;
    Uint8List bytes = base64Decode(jsonString);

    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/decoded_audio.mp3';

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    setState(() {
      _filePath = filePath;
    });
  }

  Future<void> playAudio(String audioString) async {
    await saveJsonAsMp3(audioString);
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(DeviceFileSource(_filePath!));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //after listview builder is finished
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Perform your action here
      print("ListView.builder has finished building");
      // Add your custom action code here
      if (firstTime) {
        orderIndex = -4;
      }
      firstTime = true;
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_sharp, color: Color(0xFF9474cc)),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const PatientHome()),
                      );
                    },
                  ),
                  Text(
                    'Test',
                    style: GoogleFonts.songMyung(
                      fontSize: 50,
                      color: Color(0xFF9474cc),
                      shadows: [
                        Shadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: testPerformPerson.length,
                  itemBuilder: (context, index) {
                    TestPerformPerson tpp = testPerformPerson[index];

                    //set random radio buttons
                    if (gvals.length < testPerformPerson.length) {
                      List<int> numbers = List<int>.generate(4, (i) => i);
                      numbers.shuffle(Random());

                      for (int i = 0; i < 4; i++) {
                        orderRadio or = orderRadio(text: "", value: -1, audio: "", image: '');
                        if (numbers[i] == 0) {
                          or.text = tpp.collectId.toString();
                          or.value = tpp.collectId!;
                          or.audio = tpp.audio!;
                          List<String> parts = tpp.img!.split('\\');
                          String fileName = parts.last;
                          or.image = 'Media/Person/Images/$fileName';
                        } else if (numbers[i] == 1) {
                          or.text = tpp.opt1.toString();
                          or.value = tpp.opt1!;
                          or.audio = tpp.opt1audio!;
                          List<String> parts = tpp.opt1image!.split('\\');
                          String fileName = parts.last;
                          or.image = 'Media/Person/Images/$fileName';
                        } else if (numbers[i] == 2) {
                          or.text = tpp.opt2.toString();
                          or.value = tpp.opt2!;
                          or.audio = tpp.opt2audio!;
                          List<String> parts = tpp.opt2image!.split('\\');
                          String fileName = parts.last;
                          or.image = 'Media/Person/Images/$fileName';
                        } else if (numbers[i] == 3) {
                          or.text = tpp.opt3.toString();
                          or.value = tpp.opt3!;
                          or.audio = tpp.opt3audio!;
                          List<String> parts = tpp.opt3image!.split('\\');
                          String fileName = parts.last;
                          or.image = 'Media/Person/Images/$fileName';
                        }
                        order.add(or);
                        orderIndex = orderIndex + 1;
                      }
                      gvals.add(order[orderIndex].value);
                    } else {
                      orderIndex = index * 4;
                    }

                    //it means we want patient to associate image with word in this question
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0), // Adjust the value for roundness
                            border: Border.all(color: Color.fromARGB(255, 233, 168, 71), width: 1),
                            color: Color(0xFFE9B6BF),
                          ),
                          height: 270,
                          width: 350,
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Text('${tpp.question}'),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Radio(
                                    value: order[orderIndex].value,
                                    groupValue: gvals[index],
                                    onChanged: (x) {
                                      setState(() {
                                        gvals[index] = x!;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 100,
                                    width: 70,
                                    child: Image.network("${APIHandler.baseUrlImage}${order[orderIndex].image}"),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if (order[0].audio != "") {
                                        playAudio(order[0].audio);
                                      }
                                    },
                                    icon: Icon(Icons.mic_rounded),
                                    iconSize: 30,
                                    color: Color(0xFF9474cc),
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: order[orderIndex + 1].value,
                                        groupValue: gvals[index],
                                        onChanged: (x) {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        },
                                      ),
                                      Container(
                                        height: 70,
                                        width: 70,
                                        child: Image.network("${APIHandler.baseUrlImage}${order[orderIndex + 1].image}"),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (order[1].audio != "") {
                                            playAudio(order[1].audio);
                                          }
                                        },
                                        icon: Icon(Icons.mic_rounded),
                                        iconSize: 30,
                                        color: Color(0xFF9474cc),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        value: order[orderIndex + 2].value,
                                        groupValue: gvals[index],
                                        onChanged: (x) {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        },
                                      ),
                                      Container(
                                        height: 70,
                                        width: 70,
                                        child: Image.network("${APIHandler.baseUrlImage}${order[orderIndex + 2].image}"),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (order[2].audio != "") {
                                            playAudio(order[2].audio);
                                          }
                                        },
                                        icon: Icon(Icons.mic_rounded),
                                        iconSize: 30,
                                        color: Color(0xFF9474cc),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: order[orderIndex + 3].value,
                                        groupValue: gvals[index],
                                        onChanged: (x) {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        },
                                      ),
                                      Container(
                                        height: 70,
                                        width: 70,
                                        child: Image.network("${APIHandler.baseUrlImage}${order[orderIndex + 3].image}"),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (order[3].audio != "") {
                                            playAudio(order[3].audio);
                                          }
                                        },
                                        icon: Icon(Icons.mic_rounded),
                                        iconSize: 30,
                                        color: Color(0xFF9474cc),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    );
                  },
                ),
              ),
              customButton('Finish', () async {
                List<TestResultComputation1> AssignTestData = [];
                int come, gvalCount = 0;
                var uniqueAppointmentIds = testPerformPerson.map((e) => e.AppointmentId).toSet().toList();
                int t = 1;
                int aptId = uniqueAppointmentIds[0]!;
                for (int i = 0; i < testPerformPerson.length; i++) {
                  // come = 0;
                  // TestResultComputation1 trc = TestResultComputation1(selectedOptions: [], appointmentId: -1, pid: globalPatient.pid);
                  // List<int> gval1 = [];
                  // for (int j = 0; j < testPerformPerson.length; j++) {
                  //   if (aptId == testPerformPerson[j].AppointmentId) {
                  //     gval1.add(gvals[gvalCount]);
                  //     gvalCount++;
                  //     come++;
                  //   }
                  // }
                  // trc.appointmentId = aptId;
                  // trc.selectedOptions = gval1;
                  // AssignTestData.add(trc);
                  // if (t < uniqueAppointmentIds.length) {
                  //   aptId = uniqueAppointmentIds[t]!;
                  // }
                  // i = i + come;
                  // t++;
                }
                while(gvalCount<testPerformPerson.length)
                {
                  come = 0;
                  TestResultComputation1 trc = TestResultComputation1(selectedOptions: [], appointmentId: -1, pid: globalPatient.pid);
                  List<int> gval1 = [];
                  for (int j = 0; j < testPerformPerson.length; j++) {
                    if (aptId == testPerformPerson[j].AppointmentId) {
                      gval1.add(gvals[gvalCount]);
                      gvalCount++;
                      come++;
                    }
                  }
                  trc.appointmentId = aptId;
                  trc.selectedOptions = gval1;
                  AssignTestData.add(trc);
                  if (t < uniqueAppointmentIds.length) {
                    aptId = uniqueAppointmentIds[t]!;
                  }
                  t++;
                }
                final apiHandler = APIHandler();
                final statusCode = await apiHandler.computePersonTestResult(AssignTestData);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>PatientHome()));
                // print('Response Status Code: $statusCode');
              })
            ],
          ),
        ),
      ),
    );
  }
}

class orderRadio {
  String text, audio, image;
  int value;
  orderRadio({required this.text, required this.image, required this.value, required this.audio});
}

class TestResultComputation1 {
  List<int> selectedOptions;
  int appointmentId;
  int pid;

  TestResultComputation1({
    required this.selectedOptions,
    required this.appointmentId,
    required this.pid,
  });

  Map<String, dynamic> toJson() {
    return {
      'SelectedOptions': selectedOptions,
      'AppointmentId': appointmentId,
      'Pid': pid,
    };
  }
}
