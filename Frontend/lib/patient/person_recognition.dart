import 'package:flutter_application_1/allimports.dart';
import 'package:image_picker/image_picker.dart';

class PersonRecognition extends StatefulWidget {
  const PersonRecognition({super.key});

  @override
  State<PersonRecognition> createState() => _PersonRecognitionState();
}

class _PersonRecognitionState extends State<PersonRecognition> {
  late String audio;
  String data = '';
  List<String> sentences = [];
  int sentenceIndex = 0;
  bool isLoading = false;
  late AudioPlayer _audioPlayer;
  late Person p;

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
    p = Person(name: '', age: 0, gender: '', relation: '', picPath: '');
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
              CircleAvatar(
                radius: 90,
                backgroundImage: NetworkImage("${APIHandler.baseUrlImage}${p.picPath}"),
              ),
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
              isLoading
                  ? CircularProgressIndicator()
                  : customButton('Send Image', () async {
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
                      Response r = await APIHandler().facialRecognition(img.path);
                      dynamic person = jsonDecode(r.body);
                      p.age = person["person"]["age"];
                      p.name = person["person"]["name"];
                      p.gender = person["person"]["gender"];
                      p.picPath = person["person"]["picPath"];
                      audio = person["person"]["audioPath"];
                      List<String> parts = p.picPath.split('\\');
                      String fileName = parts.last;
                      p.picPath = 'Media/Person/Images/$fileName';
                      parts = audio.split('\\');
                      fileName = parts.last;
                      audio = 'Media/Person/audio/$fileName';
                      sentences = [];
                      var ulit = person["Sentence"];
                      for (int i = 0; i < ulit.length; i++) {
                        sentences.add(ulit[i]);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }),
              SizedBox(height: 20),
              Text(
                data,
                style: TextStyle(color: Color(0xFF9474cc), fontSize: 30),
              ),
              ElevatedButton(
                onPressed: () {
                  if (sentenceIndex < sentences.length) {
                    data = sentences[sentenceIndex];
                    sentenceIndex++;
                  } else {
                    sentenceIndex = 0;
                    data = sentences[sentenceIndex];
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

class Person {
  String name;
  int age;
  String gender;
  String relation;
  String picPath;

  Person({
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
