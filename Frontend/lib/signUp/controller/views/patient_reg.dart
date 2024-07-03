import 'package:flutter_application_1/allimports.dart';
import 'package:flutter_application_1/signUp/controller/simple_ui_controller.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class PatientSignUp extends StatefulWidget {
  const PatientSignUp({Key? key}) : super(key: key);

  @override
  State<PatientSignUp> createState() => _PatientSignUpState();
}
List<bool> _selected = [true, false];
int? docId;
DateTime? _selectedDate;
List<Docs> docList=[];
class _PatientSignUpState extends State<PatientSignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? image;
  XFile? img;
  String _selectedGender = 'Male'; 
  
  final _formKey = GlobalKey<FormState>();
  late SimpleUIController simpleUIController;
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();
    super.dispose();
  }
  Future<void> allDocs()
  async {
    dynamic r=await APIHandler().allDoctorsList();
    dynamic dlist=jsonDecode(r.body);
    for(int i=0;i<dlist.length;i++)
    {
      docList.add(Docs.fromMap(dlist[i]));
    }
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allDocs();
    if(!Get.isRegistered<SimpleUIController>())
    {
      simpleUIController = Get.put(SimpleUIController());
    }else{
      simpleUIController=Get.find<SimpleUIController>();
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return _buildLargeScreen(size, simpleUIController, theme);
                } else {
                  return _buildSmallScreen(size, simpleUIController, theme);
                }
              },
            ),
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/coin.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            size.width > 600
                ? Container()
                : Lottie.asset(
                    'assets/wave.json',
                    height: size.height * 0.2,
                    width: size.width,
                    fit: BoxFit.fill,
                  ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Sign Up',
                style: kLoginTitleStyle(size),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Create Account',
                style: kLoginSubtitleStyle(size),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
        
                    
        
                    SizedBox(
                      height: size.height * 0.02,
                    ),
        
                    /// username
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
        
                      controller: nameController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        } else if (value.length < 4) {
                          return 'at least enter 4 characters';
                        } else if (value.length > 13) {
                          return 'maximum character is 13';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
        
                    /// Gmail
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_rounded),
                        hintText: 'email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter gmail';
                        } else if (!value.endsWith('@gmail.com')) {
                          return 'please enter valid gmail';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
        
        
                    /// password
                    Obx(
                      () => TextFormField(
                        style: kTextFormFieldStyle(),
                        controller: passwordController,
                        obscureText: simpleUIController.isObscure.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_open),
                          suffixIcon: IconButton(
                            icon: Icon(
                              simpleUIController.isObscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              simpleUIController.isObscureActive();
                            },
                          ),
                          hintText: 'Password',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (value.length < 7) {
                            return 'at least enter 6 characters';
                          } else if (value.length > 13) {
                            return 'maximum character is 13';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      controller: ageController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_rounded),
                        hintText: 'age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        } 
                        return null;
                      },
                    ),
                    
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 'Male',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
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
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                              const Text('Female'),
                            ],
                          )
                        ],
                      ),
        
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    ElevatedButton(onPressed: ()
                    async {
                      img=await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(img!=null)
                      {
                        image=File(img!.path);
                      }
                    }, child: Text('Select Image')),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    
                    SizedBox(
                      height: docList.length * 100.0,
                      child: ListView.builder(
                        itemCount: docList.length,
                        itemBuilder: (context,index){
                          Docs doc=docList[index];
                          List<String> parts = doc.img.split('\\');
                          String fileName = parts.last;
                          String imageUrl = 'Media/UserImages/$fileName';
                          return ListTile(
                            leading: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.network("${APIHandler.baseUrlImage}${imageUrl}")),
                            title: Text(doc.name),
                            trailing: ElevatedButton(onPressed: (){
                              docId=doc.uid;
                            },child: Text('Select'),),
                          );
                        }),
                    )  ,
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    /// SignUp Button
                    signUpButton(theme),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          if(img==null)
          {
            showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Warning'),
                      content: Text('Select an image please.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
          }else if(docId==null||docId==0)
          {
            showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Warning'),
                      content: Text('Select a doctor profile please.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
          }
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // ... Navigate To your Home Page
            int resp=await APIHandler().registerPatient(nameController.text, ageController.text,_selectedGender,emailController.text, passwordController.text, img!.path,docId.toString());
            if(resp==200)
            {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CaregiverHomeScreen()),
              );
            }
          }
        },
        child: const Text('Sign up',style:TextStyle(color: Colors.white)),
      ),
    );
  }
}
class SegmentBtn extends StatefulWidget {
  const SegmentBtn({super.key});

  @override
  _SegmentBtnState createState() => _SegmentBtnState();
}

class _SegmentBtnState extends State<SegmentBtn> {


  @override
  Widget build(BuildContext context) {
    return  Center(
        child: ToggleButtons(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Doctor'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Caregiver'),
            ),
          ],
          isSelected: _selected,
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0; buttonIndex < _selected.length; buttonIndex++) {
                if (buttonIndex == index) {
                  _selected[buttonIndex] = true;
                } else {
                  _selected[buttonIndex] = false;
                }
              }
            });
          },
        ),
      );
    
  }
}

class DobSet extends StatefulWidget {
  const DobSet({super.key});

  @override
  State<DobSet> createState() => _DobSetState();
}

class _DobSetState extends State<DobSet> {
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


class Docs
{
  int? uid;
  late String name, img;
  Docs({required this.uid,required this.name,required this.img});
  Docs.fromMap(Map<String,dynamic> map)
  {
    uid=map["uid"];
    name=map["name"];
    img=map["profPicPath"];
 }
  
}