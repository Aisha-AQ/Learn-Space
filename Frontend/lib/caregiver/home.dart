import 'package:flutter/material.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:flutter_application_1/caregiver/two_person_test.dart';
import 'package:flutter_application_1/signUp/controller/views/login_view.dart';


class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  double? animatedheight=150;
  double? leftpadding=30;
  double activityTextPadding=45;
  double leftpaddingText=50;
  double toppaddingText=40;
  double? animatedwidht=150;
  bool isCancelled = false;
  bool showImage=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPatientConnectedToCaregiver();
  }
  Future<void> checkPatientConnectedToCaregiver()
  async {
    Response r=await APIHandler().checkPatientAgainstCaregiver(globalUser.id);
    if(r.statusCode==404)
    {
       showDialog(context: context, builder: (BuildContext context)=>warningDialog('Greetings', 'Head on over to Patient Details to register your patient.', context));
    }
  }
  void ontap()async{
    
    if(!isCancelled){
        animatedheight=200;
        animatedwidht=200;
        activityTextPadding=70;
        setState(() {
          
        });
        leftpadding=10;
        leftpaddingText=17;
        toppaddingText=52;
        showImage=false;
        isCancelled=true;
    }
    else{
      animatedheight=150;
        animatedwidht=150;
        activityTextPadding=45;
        setState(() {  });
        leftpadding=30;
        leftpaddingText=50;
        toppaddingText=35;
        isCancelled=false;
        showImage=true;
      
    }
    await Future.delayed(Duration(seconds: 2));
      setState(() {});                  
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Home',style: TextStyle(color: Color(0xFF9474cc)),),
      actions: <Widget>[
          IconButton(
            icon:  Icon(Icons.logout_rounded,color:Color(0xFF9474cc) ,),// Your icon here
            onPressed: () 
            {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return LoginView();
              }));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.only(left: 15.0,top: 5),
              child: Align(
                alignment: Alignment.centerLeft,      
                child: Text('Welcome Back,\n${globalUser.name}',style: TextStyle(fontSize: 45,color: Color(0xFF9474cc)),)),
            ),
            Flexible(
              flex:1,
              child: Stack(
                alignment: AlignmentDirectional.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            GestureDetector(
                              onTap: (){
                                 Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => TwoPersonTest(showTitleTextBox: true,)),
                                    );
                              },
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0), 
                                      color: Color(0xFFF6D198),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5), // Shadow color
                                          spreadRadius: 1, // Spread radius
                                          blurRadius: 27, // Blur radius
                                          offset: Offset(0, 1), // Offset of shadow
                                        ),
                                      ],
                                    ),
                                    height: 150,
                                    width: 150,
                                  ),
                                  const Positioned(
                                    top: 13,
                                    left:15,
                                    child: Text('Person Test',style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Libre Franklin',
                                    ),)
                                  ),
                                  Positioned(
                                    top: 40,
                                    left:0,
                                    right: 2,
                                    child: Image.asset('assets/caregiverHomeScreenImage3-2.png',fit: BoxFit.fitHeight,)
                                  )
                                ],
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PersonsList()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                       boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5), // Shadow color
                                            spreadRadius: 2, // Spread radius
                                            blurRadius: 27, // Blur radius
                                            offset: Offset(0, 1), // Offset of shadow
                                          ),
                                        ],
                                      borderRadius: BorderRadius.circular(10.0), 
                                      color: Color(0xFFFE9B6BF),
                                    ),
                                    //margin: EdgeInsets.only(top:300,left: 30),
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                                const Positioned(
                                  top: 10,
                                  left:45,
                                  child: Text('People',style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Libre Franklin',
                                  ),)
                                ),
                                Positioned(
                                  top: 30 ,
                                  left:38,
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => PersonsList())));
                                    },
                                    child: Image.asset('assets/caregiverHomeScreenImage1.png',fit: BoxFit.fitHeight,))
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children:[
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ClinicalDetails()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5), // Shadow color
                                            spreadRadius: 2, // Spread radius
                                            blurRadius: 27, // Blur radius
                                            offset: Offset(0, 1), // Offset of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10.0), 
                                        color: Color(0xFFFBBE1F6),
                                      ),
                                      height: 150,
                                      width: 150,
                                    ),
                                  ),
                                  
                                  Positioned(
                                  top: 25,
                                  left:20,
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ClinicalDetails()));
                                    },
                                    child: Image.asset('assets/caregiverHomeScreenImage4.png'))
                                ),
                                const Positioned(
                                    top: 13,
                                    left:16,
                                    child: Text('Clinical Details',style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Libre Franklin',
                                    ),)
                                  ),
                                ],
                            ),
                            Stack(
                              textDirection:TextDirection. ltr,
                              alignment: AlignmentDirectional.center,
                              children:[
                                GestureDetector(
                                  onTap: ontap,
                                  child:AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    decoration: BoxDecoration(
                                       boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5), // Shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 27, // Blur radius
                                          offset: Offset(0, 1), // Offset of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.0), 
                                      color: Color(0xFFFB9C0DA),
                                    ),
                                    height: animatedheight,
                                    width: animatedwidht,
                                  ),
                                ),
                                  Positioned(
                                  top: toppaddingText,
                                  left:leftpaddingText,
                                  child:showImage?GestureDetector(
                                    child: GestureDetector(
                                      onTap:ontap,
                                      child: Image.asset('assets/caregiverHomeScreenImage2-3.png',fit: BoxFit.fitHeight,))):
                                    ActivityAnimation()
                                  ),
                                  Positioned(
                                    top: 13,
                                    left:activityTextPadding,
                                    child: Text('Activity',style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Libre Franklin',
                                    ),)
                                  ),
                                ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/caregiverHomeScreenBottomImage.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      );
      
      
      
    

  }
}
class ActivityAnimation extends StatefulWidget {
  const ActivityAnimation({super.key});

  @override
  State<ActivityAnimation> createState() => _ActivityAnimationState();
}

class _ActivityAnimationState extends State<ActivityAnimation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateActivity()),
            );
          },
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddTest(showTitleTextBox: true,)));
            },
            child: const Text('New Test',
            style: TextStyle(
              fontSize: 23,
            ),),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateActivity()));  
          },
          child: const Text('New Practice',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 23,
          ),),
        ),
        GestureDetector(
          onTap: (){
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PersonTest(showTitleTextBox: true,)),
            );
          },
          child: const Text('Person Test',style: TextStyle(
            fontSize: 23,
          ),),
        ),
        GestureDetector(
          onTap: (){
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PersonPractice()),
            );
          },
          child: const Text('Person Practice',style: TextStyle(
            fontSize: 23,
          ),),
        ),
      ],
    );
  }
}