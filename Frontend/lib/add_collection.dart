import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:flutter_application_1/custom_widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddCollection extends StatefulWidget {
  const AddCollection({super.key});

  @override
  State<AddCollection> createState() => _AddCollectionState();
}

class _AddCollectionState extends State<AddCollection> {

  TextEditingController eText = TextEditingController();
  TextEditingController uText = TextEditingController();
  File? image;
  List<String> relationDropDown=['Words','Sentences'];
  String relationChoice='Words';
  List<String> groupDropDown=[''];
  String groupChoice='';
  String groupValue = 'Simple Sentence';
  String? _filePath;
  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'],
      );

      if (result != null) {
        setState(() {
          _filePath = result.files.single.path;
        });
      } else {
        // User canceled the picker
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          customAppbarLeftDroop(screenWidth,"Collection",45,onPressed: (){Navigator.of(context).pop();}),
          const SizedBox(height: 15,),
          DropdownButton(
            value: relationChoice,
            items: relationDropDown.map((e){
              return DropdownMenuItem<String>(
                value: e,
                child: Text(e)
                );
              
            }).toList(),
            onChanged: (String? selected){
              setState(() {
                relationChoice=selected!;
              });
            },
          ),
          const SizedBox(height: 15,),
          Row(
            children: [
              Row(
                children: [
                  Radio(
                    value: 'Simple Sentence',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  const Text('Simple Sentence'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 'Person Sentence',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  const Text('Person Sentence'),
                ],
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: 5,),
              Text('English Text',style: TextStyle(fontSize: 20),),
              SizedBox(width: 13,),
                SizedBox(
                  width: 250,
                  child: customTextFormField(eText, '', ''),
                ),  
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              SizedBox(width: 5,),
              Text('Urdu Text',style: TextStyle(fontSize: 20),),
              SizedBox(width: 30,),
              SizedBox(
                width: 250,
                child: customTextFormField(uText, '', ''),
              ),  
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              const Text('Select Image',style: TextStyle(fontSize: 23,color: Color(0xFF312a3e)),),
              IconButton(onPressed: ()async{
                XFile? img=await ImagePicker().pickImage(source: ImageSource.gallery);
                if(img!=null)
                {
                  image=File(img.path);
                }
              }, iconSize: 35,icon: const Icon(Icons.add_a_photo_outlined,color: Color.fromARGB(255, 120, 84, 181),))
            ],
          ),
          SizedBox(height: 15,),
           Row(
            children: [
              const Text('Select Audio',style: TextStyle(fontSize: 23,color: Color(0xFF312a3e)),),
              IconButton(onPressed: ()async{
                  _pickAudioFile();
              }, iconSize: 35,icon: const Icon(Icons.audio_file_outlined,color: Color.fromARGB(255, 120, 84, 181),))
            ],
          ),
          const SizedBox(height: 15,),
          DropdownButton(
            hint: const Text('Select a group'),
            value: groupChoice,
            items: groupDropDown.map((e){
              return DropdownMenuItem<String>(
                value: e,
                child: Text(e)
                );
              
            }).toList(),
            onChanged: (String? selected){
              setState(() {
                groupChoice=selected!;
              });
            },
          ),
          const SizedBox(height: 15,),
          customButton('Upload Collection', () async {
            
            if(groupValue==""){
              String type='';
              if(relationChoice=="Words")
              {
                type='w';
              }else{
                type='s';
              }
              StreamedResponse resp=await APIHandler().uploadCollection(type,eText.text,uText.text,groupChoice,_filePath!,image!.path);
              if(resp.statusCode==200)
              {
                showDialog(context: context, builder: (BuildContext context)
                {
                  return AlertDialog(
                    title: const Text("Successful"),
                    content: const Text('Collection has been added succesfully!'),
                    actions: [
                      TextButton(onPressed: ()
                      {
                        Navigator.of(context).pop();
                      }, 
                      child: const Text('Close'),
                      )
                    ],
                  );
                });
              }
            }
          })
        ],
      ),
    );
  }
}