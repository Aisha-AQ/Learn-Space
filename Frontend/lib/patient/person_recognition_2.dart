import 'package:flutter_application_1/allimports.dart';
import 'package:image_picker/image_picker.dart';

class PersonRecognition2 extends StatefulWidget {
  const PersonRecognition2({super.key});

  @override
  State<PersonRecognition2> createState() => _PersonRecognition2State();
}

class _PersonRecognition2State extends State<PersonRecognition2> {
  late String audio;
  late String audio2;
  late String name;
  String data = '';
  List<String> sentences2 = [];
  int sentenceIndex = 0;
  int sentenceIndex2 = 0;
  bool isLoading = false;
  late AudioPlayer _audioPlayer;
  late Person2 p;
  late Person2 p2;
  int personIndex=0;
  int currentIndex=0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playAudio(String audioUrl) async {
    await _audioPlayer.setSourceUrl(audioUrl);
    await _audioPlayer.play(DeviceFileSource(audioUrl));
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    p = Person2(name: '', age: 0, gender: '', relation: '', picPath: '');
    p2 = Person2(name: '', age: 0, gender: '', relation: '', picPath: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF9474cc)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      currentIndex=0;
                      
                    
                      setState(() {
                        
                      });
                    },
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: NetworkImage("${APIHandler.baseUrlImage}${p.picPath}"),
                    ),
                  ),GestureDetector(
                    onTap: (){
                      currentIndex=1;
                      
                      setState(() {
                        
                      });
                    },
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: NetworkImage("${APIHandler.baseUrlImage}${p2.picPath}"),
                    ),
                  ),
                ],
              ),
              currentIndex==0? Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (audio.isNotEmpty) {
                        playAudio("${APIHandler.baseUrlImage}${audio}");
                      }
                    },
                    icon: Icon(Icons.mic_rounded),
                    iconSize: 50,
                    color: Color(0xFF9474cc),
                  ),
                  Text(
                    'Name: ${p.name}',
                    style: TextStyle(color: Color(0xFF9474cc), fontSize: 30),
                  ),
                  SizedBox(height: 3),
                  horizontalLine(MediaQuery.of(context).size.width * 0.4),
                  SizedBox(height: 8),
                  Text(
                    'Age: ${p.age}',
                    style: TextStyle(color: Color(0xFF9474cc), fontSize: 30),
                  ),
                  SizedBox(height: 3),
                  horizontalLine(MediaQuery.of(context).size.width * 0.4),
                  SizedBox(height: 8),
                  Text(
                    'Gender: ${p.gender}',
                    style: TextStyle(color: Color(0xFF9474cc), fontSize: 30),
                  ),
                  SizedBox(height: 3),
                  horizontalLine(MediaQuery.of(context).size.width * 0.4),
                  SizedBox(height: 20),
                ]
              ):
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (audio.isNotEmpty) {
                        playAudio("${APIHandler.baseUrlImage}${audio2}");
                      }
                    },
                    icon: Icon(Icons.mic_rounded),
                    iconSize: 50,
                    color: Color(0xFF9474cc),
                  ),
                  Text(
                    'Name: ${p2.name}',
                    style: TextStyle(color: Color(0xFF9474cc), fontSize: 30),
                  ),
                  SizedBox(height: 3),
                  horizontalLine(MediaQuery.of(context).size.width * 0.4),
                  SizedBox(height: 8),
                  Text(
                    'Age: ${p2.age}',
                    style: TextStyle(color: Color(0xFF9474cc), fontSize: 30),
                  ),
                  SizedBox(height: 3),
                  horizontalLine(MediaQuery.of(context).size.width * 0.4),
                  SizedBox(height: 8),
                  Text(
                    'Gender: ${p2.gender}',
                    style: TextStyle(color: Color(0xFF9474cc), fontSize: 30),
                  ),
                  SizedBox(height: 3),
                  horizontalLine(MediaQuery.of(context).size.width * 0.4),
                  SizedBox(height: 20),
                ]
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : customButton('Send Image', () async {
                      if(personIndex==0)
                      {
                        setState(() {
                          isLoading = true;
                        });

                        XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (img == null) {
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                        Response r = await APIHandler().facialRecognition2(img.path,'p');
                        dynamic person = jsonDecode(r.body);
                        p.age = person["age"];
                        p.name = person["name"];
                        name=p.name;
                        p.gender = person["gender"];
                        p.picPath = person["picPath"];
                        audio = person["audioPath"];
                        List<String> parts = p.picPath.split('\\');
                        String fileName = parts.last;
                        p.picPath = 'Media/Person/Images/$fileName';
                        parts = audio.split('\\');
                        fileName = parts.last;
                        audio = 'Media/Person/audio/$fileName';
                        
                        // var ulit = person["Sentence"];
                        // for (int i = 0; i < ulit.length; i++) {
                        //   sentences.add(ulit[i]);
                        // }
                        personIndex++;
                        // data = sentences[sentenceIndex];
                        setState(() {
                          isLoading = false;
                        });
                      }else
                      {
                        setState(() {
                          isLoading = true;
                        });

                        XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (img == null) {
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                        Response r = await APIHandler().facialRecognition2(img.path,name);
                        dynamic person = jsonDecode(r.body);
                        p2.age = person["person"]["age"];
                        p2.name = person["person"]["name"];
                        p2.gender = person["person"]["gender"];
                        p2.picPath = person["person"]["picPath"];
                        audio2 = person["person"]["audioPath"];
                        List<String> parts = p2.picPath.split('\\');
                        String fileName = parts.last;
                        p2.picPath = 'Media/Person/Images/$fileName';
                        parts = audio2.split('\\');
                        fileName = parts.last;
                        audio2 = 'Media/Person/audio/$fileName';
                        sentences2=[];
                        var ulit = person["Sentence"];
                        for (int i = 0; i < ulit.length; i++) {
                          sentences2.add(ulit[i]);
                        }
                        personIndex--;
                        data = sentences2[sentenceIndex2];
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }),
              SizedBox(height: 20),
              Text(
                data,
                style: TextStyle(color: Color(0xFF9474cc), fontSize: 30),
              ),
              ElevatedButton(
                onPressed: () {
                    sentenceIndex2++;
                    if (sentenceIndex2 < sentences2.length) {
                    
                    data = sentences2[sentenceIndex2];
                    
                    } else {
                      sentenceIndex2 = 0;
                      data = sentences2[sentenceIndex2];
                    }
                  
                  setState(() {});
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Person2 {
  String name;
  int age;
  String gender;
  String relation;
  String picPath;

  Person2({
    required this.name,
    required this.age,
    required this.gender,
    required this.relation,
    required this.picPath,
  });
}

Widget horizontalLine(double width) {
  return Container(
    width: width,
    height: 1.0,
    color: Colors.grey,
  );
}

Widget customButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(text),
  );
}
