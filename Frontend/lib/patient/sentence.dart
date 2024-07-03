import 'package:blobs/blobs.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SentenceActivity extends StatefulWidget {
  late PatientPractice p;
  SentenceActivity({super.key, required this.p});

  @override
  State<SentenceActivity> createState() => _SentenceActivityState();
}

class _SentenceActivityState extends State<SentenceActivity> {
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
  Future<void> playAudio() async {
    await saveJsonAsMp3(widget.p.collectionlist[indexPracitce].audioPath!);
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Color(0xFF9474cc)),
          onPressed: () {
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
                      id: ['14-6-3118'],
                      size: 400,
                      styles: BlobStyles(
                        color: Color(0xFFF1CCF2),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.2,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Image.memory(base64Decode(widget.p.collectionlist[indexPracitce].picPath!)),
                          Container(
                            width: 300,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              child: AutoSizeText(
                                widget.p.collectionlist[indexPracitce].eText!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sahitya(
                                  fontSize: 30,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFF9474cc).withOpacity(0.9),
                                      offset: Offset(2, 4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                maxLines: 3, // You can set the maximum number of lines here
                                minFontSize: 10, // Set the minimum font size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if(widget.p.collectionlist[indexPracitce].audioPath!=null&&widget.p.collectionlist[indexPracitce].audioPath!="")
                {
                  playAudio();
                }
              },
              icon: Icon(Icons.mic_rounded),
              iconSize: 50,
              color: Color(0xFF9474cc),
            ),
            SizedBox(height: 7),
            SizedBox(
              width: 140,
              height: 40,
              child: indexPracitce != widget.p.collectionlist.length - 1
                  ? ElevatedButton(
                      onPressed: () {
                        indexPracitce++;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SentenceActivity(p: widget.p),
                          ),
                        );
                      },
                      child: Text('Next  >>'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        indexPracitce = 0;
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PatientHome()),
                        );
                      },
                      child: Text('Finish'),
                    ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
