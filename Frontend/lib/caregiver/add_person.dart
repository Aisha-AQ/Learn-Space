import 'package:flutter/services.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:audioplayers/audioplayers.dart';

class NewPerson extends StatefulWidget {
  const NewPerson({super.key});

  @override
  State<NewPerson> createState() => _NewPersonState();
}
DateTime? _selectedDate;
class _NewPersonState extends State<NewPerson> {
  TextEditingController name = TextEditingController();
  TextEditingController relation=TextEditingController();
  File? image;
  int c=0;
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
  String groupValue = 'Male';
  @override
  Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          customAppbarLeftDroop(screenWidth,"Add Person",45,onPressed: (){Navigator.of(context).pop();}),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.only(left:11.0, top: 20),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  SizedBox(
                    width: 350,
                    child: customTextFormField(name, 'Name', 'Name'),
                  ),  
                  
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 350,
                    child: customTextFormField(relation, 'Relation', 'Relation'),
                  ),  
                  const SizedBox(height: 25,),
                  const Text('Gender',
                  style: TextStyle(fontSize: 23,color: Color(0xFF312a3e)),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: groupValue,
                            onChanged: (value) {
                              setState(() {
                                groupValue = value!;
                              });
                            },
                          ),
                          const Text('Male'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'Female',
                            groupValue: groupValue,
                            onChanged: (value) {
                              setState(() {
                                groupValue = value!;
                              });
                            },
                          ),
                          const Text('Female'),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 5,),
                  horizontalLine(350),
                  const SizedBox(height: 5,),
                  const Text('Date of Birth',style: TextStyle(fontSize: 23,color: Color(0xFF312a3e)),),
                  const MyHomePage(),
                  const SizedBox(height: 5,),
                  horizontalLine(350),
                  const SizedBox(height: 23,),
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
                  const SizedBox(height: 30,),
                   Row(
                    children: [
                      const Text('Select Audio',style: TextStyle(fontSize: 23,color: Color(0xFF312a3e)),),
                      IconButton(onPressed: ()async{
                         _pickAudioFile();
                      }, iconSize: 35,icon: const Icon(Icons.audio_file_outlined,color: Color.fromARGB(255, 120, 84, 181),))
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left:110.0),
                    child: customButton('Save', () async {
                    if(name.text==""||_selectedDate==null||relation.text==""||image==null||_filePath==null)
                    {
                      showDialog(
                        context: context,
                        builder:(context) => warningDialog("Warning", "Please make sure all the fields are filled.", context));
                    }else
                    {
                      int age=DateTime.now().year-_selectedDate!.year;
                    var audPath="/Users/dpl/Documents/flutterProjects/flutter_application_1/assets/audios/Aisha.m4a";
                    String im='/Users/dpl/Documents/flutterProjects/flutter_application_1/assets/caregiverHomeScreenImage8.png';
                    
                     c=await  APIHandler().uploadperson(name.text,groupValue,age.toString(),relation.text,_filePath!,globalUser.id,image!.path,0);
                     if(c==409)
                     {
                        showDialog(context: context,
                         builder: (BuildContext context)
                         {
                          return AlertDialog(
                          title: const Text('Problem'),
                          content: Text('Person data already exists against ${name.text} with the relation ${relation.text} '),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            
                          ],
                  
                        );
                         });

                     }else if(c==300)
                     {
                      showDialog(context: context,
                        builder: (BuildContext context)
                        {
                        return AlertDialog(
                        title: const Text('Problem'),
                        content: Text('Person data already exists against ${name.text}\nDo you want to continue?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: ()async {
                              await  APIHandler().uploadperson(name.text,groupValue,age.toString(),relation.text,audPath,5,im,1);
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );});
                      }else if(c==200)
                     {
                      showDialog(context: context,
                        builder: (BuildContext context)
                        {
                        return AlertDialog(
                        title: const Text('Successful'),
                        content: Text('Data saved Successfully!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Ok'),
                          ),
                          
                        ],
                      );});
                      }else if(c==500)
                     {
                      showDialog(context: context,
                        builder: (BuildContext context)
                        {
                        return AlertDialog(
                        title: const Text('Error'),
                        content: Text('There was a problem saving data, Please re-check fields and try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Ok'),
                          ),
                          
                        ],
                      );});
                      }
                    }
                    
                    }
                    ),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.calendar_today,color: Color.fromARGB(255, 120, 84, 181),),
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
            style: const TextStyle(fontSize: 20),
          ),
      ],
    );
  }
}


