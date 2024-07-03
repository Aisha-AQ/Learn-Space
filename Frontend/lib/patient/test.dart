import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_application_1/Models/patient_test.dart';
import 'package:flutter_application_1/allimports.dart';

class TestPatient extends StatefulWidget {
  late int testid;
  TestPatient({super.key,required this.testid});

  @override
  State<TestPatient> createState() => _TestPatientState();
}
 PatientTest pttest=PatientTest(testId: -1, testCollectionlist: [],aptid: -1);
class _TestPatientState extends State<TestPatient> {
  List<int> gvals=[];
  List<orderRadio> order=[];
  bool _isLoading = true;
  Future<void> getTestInfo()
  async {
    //to empty at start in case of leftover data
    pttest=PatientTest(testId: -1, testCollectionlist: [],aptid: -1);
    gvals=[];
    order=[];
    Response r=await APIHandler().patientTests(globalPatient.pid);
    dynamic tlist=jsonDecode(r.body);
    for(int i=0;i<tlist.length;i++){
      if(tlist[i]["TestId"]==widget.testid)
      {
        TestPerformPatient.fromMap(tlist[i],widget.testid);
        break;
      }
      
    }
    pttest.testId=widget.testid;
    setState(() {
      _isLoading=false;
    });
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
    _filePath=null;
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: 
           _isLoading
                  ? Center(child: CircularProgressIndicator()):
          Column(
            children: [
              Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_sharp,color: Color(0xFF9474cc),), 
                      onPressed: () 
                      {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const PatientHome()),
                        );
                      },
                    ),
                    Text('Test',
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
              SizedBox(height: 30,),
              Expanded(
                child: ListView.builder(
                  itemCount: pttest.testCollectionlist.length,
                  itemBuilder: (context,index) 
                  {
                    TestPerformPatient tpp=pttest.testCollectionlist[index];
                     
                    //set random radio buttons
                    
                    if(gvals.length<pttest.testCollectionlist.length)
                    {
                      List<int> numbers = List<int>.generate(4, (i) => i);
                    numbers.shuffle(Random());
                   
                    for(int i=0; i<4; i++)
                    {
                      orderRadio or=orderRadio(text: "", value: -1,audio: "");
                      if(numbers[i]==0)
                      {
                        or.text=tpp.etext!;
                        or.value=tpp.collectId!;
                        or.audio=tpp.audio!;
                      }else if(numbers[i]==1)
                      {
                        or.text=tpp.opt1eText!;
                        or.value=tpp.opt1!;
                        or.audio=tpp.opt1audio!;
                      }else if(numbers[i]==2)
                      {
                        or.text=tpp.op2eText!;
                        or.value=tpp.opt2!;
                        or.audio=tpp.opt2audio!;
                      }else if(numbers[i]==3)
                      {
                        or.text=tpp.opt3eText!;
                        or.value=tpp.opt3!;
                        or.audio=tpp.opt3audio!;
                      }
                      order.add(or);
                    }
                      gvals.add(order[0].value);
                    }
                    
                    //it means we want patoent to associate image with word in this question
                    if(tpp.question=="")
                    {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the value for roundness
                              border: Border.all(color: Color.fromARGB(255, 233, 168, 71), width:1),
                              color: Color(0xFFE9B6BF),
                              
                            ),
                            height: 270,
                            width: 350,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.memory(base64Decode(tpp.img!))),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 25,),
                                        Radio(
                                        value: order[0].value,
                                        groupValue: gvals[index], 
                                        onChanged: (x)
                                        {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        }),Text(order[0].text),
                                        IconButton(onPressed: () async {
                                          if(order[0].audio!="")
                                          {
                                            playAudio(order[0].audio);
                                          }
                                        }, icon: Icon(Icons.mic_rounded),iconSize: 30,color:Color(0xFF9474cc) ,),
                                      ],
                                    ),
                                    //SizedBox(width: 100,),
                                    Row(
                                      children: [
                                        Radio(
                                        value: order[1].value,
                                        groupValue: gvals[index], 
                                        onChanged: (x)
                                        {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        }),Text(order[1].text),
                                        IconButton(onPressed: () async {
                                          if(order[1].audio!="")
                                          {
                                            playAudio(order[1].audio);
                                          }
                                        }, icon: Icon(Icons.mic_rounded),iconSize: 30,color:Color(0xFF9474cc) ,),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 25,),
                                        Radio(
                                        value: order[2].value,
                                        groupValue: gvals[index], 
                                        onChanged: (x)
                                        {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        }),Text(order[2].text),
                                        IconButton(onPressed: () async {
                                          if(order[2].audio!="")
                                          {
                                            playAudio(order[2].audio);
                                          }
                                        }, icon: Icon(Icons.mic_rounded),iconSize: 30,color:Color(0xFF9474cc) ,),
                                      ],
                                    ),
                                   // SizedBox(width: 100,),
                                    Row(
                                      children: [
                                        Radio(
                                        value: order[3].value,
                                        groupValue: gvals[index], 
                                        onChanged: (x)
                                        {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        }),Text(order[3].text),
                                        IconButton(onPressed: () async {
                                          if(order[3].audio!="")
                                          {
                                            playAudio(order[3].audio);
                                          }
                                        }, icon: Icon(Icons.mic_rounded),iconSize: 30,color:Color(0xFF9474cc) ,),
                                      ],
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                          SizedBox(height: 50,),
                        ],
                      );
                    }else
                    {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the value for roundness
                              border: Border.all(color: Color.fromARGB(255, 233, 168, 71), width:1),
                              color: Color(0xFFE9B6BF),
                              
                            ),
                            height: 220,
                            width: 350,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                AutoSizeText(
                                  tpp.question!,
                                  style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                ),
                                SizedBox(height: 50,),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 25,),
                                        Radio(
                                        value: order[0].value,
                                        groupValue: gvals[index], 
                                        onChanged: (x)
                                        {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        }),Text(order[0].text),IconButton(onPressed: () async {
                                          if(order[0].audio!="")
                                          {
                                            playAudio(order[0].audio);
                                          }
                                        }, icon: Icon(Icons.mic_rounded),iconSize: 30,color:Color(0xFF9474cc) ,),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                        value: order[1].value,
                                        groupValue: gvals[index], 
                                        onChanged: (x)
                                        {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        }),Text(order[1].text),
                                        IconButton(onPressed: () async {
                                          if(order[1].audio!="")
                                          {
                                            playAudio(order[1].audio);
                                          }
                                        }, icon: Icon(Icons.mic_rounded),iconSize: 30,color:Color(0xFF9474cc) ,),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 25,),
                                        Radio(
                                        value: order[2].value,
                                        groupValue: gvals[index], 
                                        onChanged: (x)
                                        {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        }),Text(order[2].text),
                                        IconButton(onPressed: () async {
                                          if(order[2].audio!="")
                                          {
                                            playAudio(order[2].audio);
                                          }
                                        }, icon: Icon(Icons.mic_rounded),iconSize: 30,color:Color(0xFF9474cc) ,),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                        value: order[3].value,
                                        groupValue: gvals[index], 
                                        onChanged: (x)
                                        {
                                          setState(() {
                                            gvals[index] = x!;
                                          });
                                        }),Text(order[3].text),
                                        IconButton(onPressed: () async {
                                          if(order[3].audio!="")
                                          {
                                            playAudio(order[3].audio);
                                          }
                                        }, icon: Icon(Icons.mic_rounded),iconSize: 30,color:Color(0xFF9474cc) ,),
                                      ],
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                          SizedBox(height: 50,),
                        ],
                      ); 
                    }
                  }
                )
              ),
              customButton('Finish', () async {
                List<TestResultComputation> AssignTestData = [
                  TestResultComputation(
                    selectedOptions: gvals,
                    appointmentId: pttest.aptid,
                    pid: globalPatient.pid,
                    testid: widget.testid
                  ),
                ];
                final apiHandler = APIHandler();
                final statusCode = await apiHandler.computeTestResult(AssignTestData);
                if(statusCode==200)
                {
                  Navigator.of(context).pop();
                }
                print('Response Status Code: $statusCode');
                int h=0;
              })
            ],
          )
        ),
      ),
    );
  }
}
class orderRadio
{
  String text,audio;
  int value;
  orderRadio({required this.text,required this.value,required this.audio});
}
class TestResultComputation {
  List<int> selectedOptions;
  int appointmentId,testid;
  int pid;

  TestResultComputation({
    required this.selectedOptions,
    required this.appointmentId,
    required this.pid,
    required this.testid,
  });

  Map<String, dynamic> toJson() {
    return {
      'SelectedOptions': selectedOptions,
      'AppointmentId': appointmentId,
      'Pid': pid,
      'TestId': testid,
    };
  }
}