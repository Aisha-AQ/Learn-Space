import 'package:flutter_application_1/allimports.dart';
import 'package:blobs/blobs.dart';

class PracticePerson extends StatefulWidget {
  PracticePerson({super.key});

  @override
  State<PracticePerson> createState() => _PracticePersonState();
}

class _PracticePersonState extends State<PracticePerson> {
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
  Future<void> playAudio(String audioUrl) async {
    await _audioPlayer.setSourceUrl(audioUrl);
    await _audioPlayer.play(DeviceFileSource(audioUrl));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<String> parts = personPrac[indexPersonPracitce].img.split('\\');
    String fileName = parts.last;
    personPrac[indexPersonPracitce].img = 'Media/Person/Images/$fileName';
    parts = personPrac[indexPersonPracitce].audio.split('\\');
    fileName = parts.last;
    personPrac[indexPersonPracitce].audio = 'Media/Person/audio/$fileName';
  }
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Text('< Back',style: TextStyle(color: Color(0xFF9474cc)),),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp,color: Color(0xFF9474cc),), 
            onPressed: () 
            {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PatientHome()),
              );
            },
          ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Blob.fromID(
                      id: ['20-8-3118'],
                      size: 400,
                      styles: BlobStyles(
                        color: Color(0xFFF1CCF2), // Set your desired color here
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 80,
                      child: Container(
                        height: 190,
                        width: 190,
                        child:  Image.network("${APIHandler.baseUrlImage}${personPrac[indexPersonPracitce].img}"),
                        ),
                    ),
                    Positioned(
                      top: 220,
                      child: Text(
                        personPrac[indexPersonPracitce].name,
                        style: GoogleFonts.sahitya(
                          fontSize: 70,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.grey.withOpacity(0.7),
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),)
                  ],
                ),
              ),
            ),
            IconButton(onPressed: () async {
              if(personPrac[indexPersonPracitce].audio!="")
              {
                playAudio("${APIHandler.baseUrlImage}${personPrac[indexPersonPracitce].audio}");
              }
            }, icon: Icon(Icons.mic_rounded),iconSize: 50,color:Color(0xFF9474cc) ,),
            
            SizedBox(height: 7), 
            SizedBox(
              width: 140,
              height: 40,
              child: indexPersonPracitce!=personPrac.length-1? ElevatedButton(onPressed: (){
                indexPersonPracitce++;
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PracticePerson()));
              }, child: Text('Next  >>')):ElevatedButton(onPressed: (){
                indexPersonPracitce=0;
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PatientHome()));
              }, child: Text('Finish')),),
            SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}

class AssignedPersonPractice
{
  late String img,name,audio;
  AssignedPersonPractice.fromMap(Map<String,dynamic> map){
    img=map["Path"];
    name=map["Name"];
    audio=map["collectAudio"];
  }
}