import 'package:flutter/material.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:get/get.dart';

class ClinicalDetails extends StatefulWidget {
  const ClinicalDetails({super.key});

  @override
  State<ClinicalDetails> createState() => _ClinicalDetailsState();
}

class _ClinicalDetailsState extends State<ClinicalDetails> {
  double? animatedheight=150;
  double? leftpadding=30;
  double activityTextPadding=45;
  double leftpaddingText=50;
  double toppaddingText=35;
  double? animatedwidht=150;
  bool isCancelled = false;
  bool showImage=true;

  Future<void> _showRadioButtonDialog(String text) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select an Option'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Regular $text'),
                    leading: Radio<String>(
                      value: 'Regular Practice',
                      groupValue: _selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Person $text'),
                    leading: Radio<String>(
                      value: 'Person Practice',
                      groupValue: _selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedOption);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _selectedOption = 'Regular Practice';

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
        setState(() {
          
        });
        
        leftpadding=30;
        leftpaddingText=50;
        toppaddingText=35;
        isCancelled=false;
        showImage=true;
      
    }
    await Future.delayed(const Duration(seconds: 2));
      setState(() {
    });                  
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Home',style: TextStyle(color: Color.fromARGB(255, 245, 245, 245)),),
      backgroundColor: const Color(0xFF9474cc),
      leading: IconButton(
        icon:  const Icon(Icons.arrow_back_ios_new,color:Color.fromARGB(255, 225, 222, 230) ,),// Your icon here
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
     
      ),
      body: Center(
        child: Column(
          children: [
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
                              onTap: ()
                              {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                  return HistoryPatient(name: "");
                                }));
                              },
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0), 
                                      color: const Color(0xFFF6D198),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4), // Shadow color
                                          spreadRadius: 1, // Spread radius
                                          blurRadius: 27, // Blur radius
                                          offset: const Offset(0, 1), // Offset of shadow
                                        ),
                                      ],
                                    ),
                                    height: 150,
                                    width: 150,
                                  ),
                                  const Positioned(
                                    top: 13,
                                    left:25,
                                    child: Text('Visit History',style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Libre Franklin',
                                    ),)
                                  ),
                                  Positioned(
                                    top: 7,
                                    left:0,
                                    right: 2,
                                    child: Image.asset('assets/caregiverHomeScreenImage8.png',fit: BoxFit.scaleDown,)
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: ()
                              {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NextAppointmentCard()));
                              },
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 2, 
                                            blurRadius: 27, 
                                            offset: const Offset(0, 1), 
                                          ),
                                        ],
                                      borderRadius: BorderRadius.circular(10.0), 
                                      color: const Color(0xFFFE9B6BF),
                                    ),
                                    height: 150,
                                    width: 150,
                                  ),
                                  const Positioned(
                                    top: 13,
                                    left:35,
                                    child: Text('Next Visit',style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Libre Franklin',
                                    ),)
                                  ),
                                  Positioned(
                                    top: 40  ,
                                    left:6,
                                    child: Image.asset('assets/caregiverHomeScreenImage5.png',fit: BoxFit.fitHeight,)
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            GestureDetector(
                              onTap: ()
                              async {
                                await _showRadioButtonDialog("Test");
                                if(_selectedOption=="Regular Practice")
                                {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TestList()));
                                }else
                                {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AssignPersonTest()));
                                }
                              },
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children:[
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4), // Shadow color
                                            spreadRadius: 2, // Spread radius
                                            blurRadius: 27, // Blur radius
                                            offset: const Offset(0, 1), // Offset of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10.0), 
                                        color: const Color(0xFFFBBE1F6),
                                      ),
                                      height: 150,
                                      width: 150,
                                      child: FittedBox(
                                        child: Image.asset('assets/caregiverHomeScreenImage6.png'),
                                      ),
                                    ),
                                  const Positioned(
                                      top: 13,
                                      left:56,
                                      child: Text('Test',style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Libre Franklin',
                                      ),)
                                    ),
                                  ],
                              ),
                            ),
                            GestureDetector(
                              onTap: ()
                              async {
                                await _showRadioButtonDialog("Activity");
                                if(_selectedOption=="Regular Practice")
                                {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ActivityList()));
                                }else
                                {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AssignPersonPractice()));
                                }
                              },
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4), // Shadow color
                                            spreadRadius: 2, // Spread radius
                                            blurRadius: 27, // Blur radius
                                            offset: const Offset(0, 1), // Offset of shadow
                                          ),
                                        ],
                                      borderRadius: BorderRadius.circular(10.0), 
                                      color: const Color(0xFFFB9C0DA),
                                    ),
                                    //margin: EdgeInsets.only(top:300,left: 30),
                                    height: 150,
                                    width: 150,
                                  ),
                                  const Positioned(
                                    top: 13,
                                    left:35,
                                    child: Text('Practices',style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Libre Franklin',
                                    ),)
                                  ),
                                  Positioned(
                                    top: 40  ,
                                    left:15,
                                    child: Image.asset('assets/caregiverHomeScreenImage7.png',fit: BoxFit.fitHeight,)
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
