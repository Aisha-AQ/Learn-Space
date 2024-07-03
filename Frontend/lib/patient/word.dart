import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:blobs/blobs.dart';
import 'package:flutter_application_1/Models/patient_practice.dart';
import 'package:flutter_application_1/global.dart';
import 'package:flutter_application_1/patient/home.dart';
import 'package:google_fonts/google_fonts.dart';

class WordActivity extends StatefulWidget {
  late PatientPractice p;
  WordActivity({super.key,required this.p});

  @override
  State<WordActivity> createState() => _WordActivityState();
}

class _WordActivityState extends State<WordActivity> {
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
                        child: Image.memory(base64Decode(widget.p.collectionlist[indexPracitce].picPath!)),
                        ),
                    ),
                    Positioned(
                      top: 220,
                      child: Text(
                        widget.p.collectionlist[indexPracitce].eText!,
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
              if(widget.p.collectionlist[indexPracitce].audioPath!=null&&widget.p.collectionlist[indexPracitce].audioPath!="")
              {
                playAudio();
              }
            }, icon: Icon(Icons.mic_rounded),iconSize: 50,color:Color(0xFF9474cc) ,),
            // Add any additional widgets below 'f' if needed
            SizedBox(height: 7), 
            SizedBox(
              width: 140,
              height: 40,
              child: indexPracitce!=widget.p.collectionlist.length-1? ElevatedButton(onPressed: (){
                indexPracitce++;
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WordActivity(p:widget.p)));
              }, child: Text('Next  >>')):ElevatedButton(onPressed: (){
                indexPracitce=0;
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PatientHome()));
              }, child: Text('Finish')),),
            SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
