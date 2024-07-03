import 'package:flutter_application_1/allimports.dart';
import 'package:flutter_application_1/patient/person_recognition.dart';
import 'package:flutter_application_1/patient/person_test.dart';
import 'package:flutter_application_1/signUp/controller/views/login_view.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}
List<Collection> collist=[];
PatientPractice pp = PatientPractice(collectionlist: [], pid: -1,title: ""); 
class _PatientHomeState extends State<PatientHome> {
  bool isLoading=true;
  Future<void> getPractices()
  async {
    indexPracitce=0;
    pp = PatientPractice(collectionlist: [], pid: -1,title: ""); 
    patient_practice=[];
    final now = DateTime.now();
    //because server laptop date is a day behind
    final yesterday = now.subtract(const Duration(days: 1));
    var response=await APIHandler().patientPractices(globalPatient.pid, now);
    if(response.statusCode==200)
    {
      dynamic ulist=jsonDecode(response.body);
      for(int i=0;i<ulist.length;i++){
        collist.add(Collection.fromMap1(ulist[i]));
      }
    }
    
    setState((){
      isLoading=false;
      patient_practice;});
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPractices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home',style: TextStyle(color: Color(0xFF9474cc)),),
        leading: IconButton(
            icon: const Icon(Icons.menu,color: Color(0xFF9474cc),), 
            onPressed: () {
            },
          ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.03),
            child:  Text('Welcome Back\n${globalPatient.name}',style: TextStyle(fontSize: 35,color: Color(0xFF9474cc),fontWeight: FontWeight.w600),),
          ),
          const SizedBox(height: 30,),
          Stack(
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
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => PersonRecognition()),
                              );
                            },
                            child: Stack(
                                alignment: AlignmentDirectional.center,
                                children:[
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.6), 
                                            spreadRadius: 2, 
                                            blurRadius: 27, 
                                            offset: const Offset(0, 1), 
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10.0), 
                                        color: const Color(0xFFFE9B6BF),
                                      ),
                                      height: 140,
                                      width: 140,
                                    ),
                                   const Positioned(
                                  top: 5,
                                  left:18,
                                  child: Column(
                                    children: [
                                      Text('Face',style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Libre Franklin',
                                      ),),
                                      Text('Identification',style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Libre Franklin',
                                      ),),
                                    ],
                                  )
                                ),
                                Positioned(
                                  top: 50,
                                  left:0,
                                  right: 0,
                                  child: SizedBox(
                                    height: 80,
                                    width: 0,
                                    child: Image.asset('assets/Removal-572.png'),
                                  )
                                )
                                  ],
                              ),
                          ),
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => TestListPatient()),
                              );
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                     boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5), 
                                          spreadRadius: 2, 
                                          blurRadius: 27, 
                                          offset: const Offset(0, 1), 
                                        ),
                                      ],
                                    borderRadius: BorderRadius.circular(10.0), 
                                    color: const Color(0xFFFBBE1F6),
                                  ),
                                  height: 140,
                                  width: 140,
                                ),
                                const Positioned(
                                  top: 10,
                                  left:50 ,
                                  child: Text('Test',style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Libre Franklin',
                                  ),)
                                ),
                                Positioned(
                                  top: 30,
                                  right: 0,
                                  left:0,
                                  child: Image.asset('assets/caregiverHomeScreenImage6.png',width: 200,)
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),ElevatedButton(onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TestPerson()));
                    }, child: Text('Person Test')),
                ElevatedButton(onPressed: () async {
                    personPrac=[];
                    indexPersonPracitce=0;
                    Response r = await APIHandler().assignedPersonPractices(1);
                    dynamic tlist = jsonDecode(r.body);
                    for (int i = 0; i < tlist.length; i++) {
                      personPrac.add(AssignedPersonPractice.fromMap(tlist[i]));
                    }
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PracticePerson()));
                    }, child: Text('Person Practice')),
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.03),
            child: const Text('Practices:',style: TextStyle(color: Color(0xFF9474cc),fontSize: 25,fontWeight:FontWeight.w500)),
          ),
          
          Expanded(
            child: Stack(
              children:[
                Positioned(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/2-47,
                    child: Image.asset('assets/backgroundPatientHome.png',alignment: Alignment.bottomCenter,)),
                ),
                isLoading?const Padding(
                  padding: EdgeInsets.only(left:160,top:50),
                  child: CircularProgressIndicator(),
                ):patient_practice.length==0?Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('No Practices'),
                ):
                ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: patient_practice.length,  
                itemBuilder: (c,index)
                {
                  PatientPractice ptprac=patient_practice[index];
                  return Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07,top: MediaQuery.of(context).size.height*0.03),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                      if(ptprac.collectionlist[0].type=="a")
                                      {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)
                                        {
                                          return AlphabetActivity(p:patient_practice[index]);
                                        }));
                                      }
                                      else if(ptprac.collectionlist[0].type=="w")
                                      {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)
                                        {
                                          return WordActivity(p:patient_practice[index]);
                                        }));
                                      }
                                    },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 27,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 130,
                                          width: 220,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: const Color.fromARGB(255, 94, 90, 90),
                                            ),
                                              color: Colors.amber,
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                'assets/image 5-2.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            if(ptprac.collectionlist[0].type=="a")
                                            {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)
                                              {
                                                return AlphabetActivity(p:patient_practice[index]);
                                              }));
                                            } else if(ptprac.collectionlist[0].type=="w")
                                            {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)
                                              {
                                                return WordActivity(p:patient_practice[index]);
                                              }));
                                            }else if(ptprac.collectionlist[0].type=="s")
                                            {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)
                                              {
                                                return SentenceActivity(p:patient_practice[index]);
                                              }));
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                              width: 1, // Choose the width of the border
                                              color: const Color.fromARGB(255, 94, 90, 90),
                                            ),
                                            color: Colors.white70,
                                            ),
                                            height: 80,
                                            width: 220,
                                            child:  Padding(
                                              padding: const EdgeInsets.only(left:12.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(ptprac.title,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 20,),)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 10,),
                            
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                );
                })
              ]
            ),
          ),
        ],
      ),
    );
  }
}

