import 'package:flutter_application_1/Models/docPatientApt.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:flutter_application_1/signUp/controller/views/login_view.dart';
import 'package:intl/intl.dart';

class DocHome extends StatefulWidget {
  const DocHome({super.key});

  @override
  State<DocHome> createState() => _DocHomeState();
}

class _DocHomeState extends State<DocHome> {

  List<DocPatientApt> dpalist=[];
  Future<void> getApt()
  async {
    Response response=await APIHandler().getAppointments(globalUser.id, DateTime.now()); 
    dynamic ulist=jsonDecode(response.body);
    
    for(int i=0;i<ulist.length;i++){
      Map<String,dynamic> map=ulist[i];
      Appointment ap=Appointment.fromMap(map["appointment"]);
      Patient p=Patient.fromMap(map["patients"]);
      DocPatientApt dpa=DocPatientApt(pat: p, ap: ap);
      dpalist.add(dpa);
      //dpa.add(DocPatientApt.fromMap(ulist[i]));
    }
    setState(() {
      
    });
  }
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getApt();
    //items=alphabets;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
                icon: const Icon(Icons.menu,color: Color(0xFF9474cc),), 
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
          }
        ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_outlined,color: Color(0xFF9474cc),),
              onPressed: () {
              },
            ),
          ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                globalUser.name,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 166, 10, 227),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Update the state of the app
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.create_sharp),
              title: Text('Create Activity'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateActivity()));
              },
            ),
            ListTile(
              leading: Icon(Icons.create_sharp),
              title: Text('Create Test'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddTest(showTitleTextBox: true),
                      ),
                    );
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Schedule Appointment'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddAppointment(name: "",)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_turned_in_sharp),
              title: const Text('My Tests'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AssignTest(viewOnly: true,)));
              },
            ),
            ListTile(
              leading: Icon(Icons.text_snippet),
              title: const Text('My Practices'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AssignActivity(viewOnly: true,)));
              },
            ),
            ListTile(
              leading: Icon(Icons.text_snippet),
              title: const Text('My Patients'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyPatients()));
              },
            ),
            ListTile(
              leading: Icon(Icons.text_snippet),
              title: const Text('Requests'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RequestPatient()));
              },
            ),
            ListTile(
              leading: Icon(Icons.login_rounded),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginView()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top:13.0,left: MediaQuery.of(context).size.width*0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage("${APIHandler.baseUrlImage}${globalUser.profPicPath}")// MemoryImage(base64Decode(globalUser.profPicPath)) 
                  ,radius: 70,
                ),
                SizedBox(width: 15,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Professional',style: TextStyle(color: Color(0xFF9474cc),),),
                    Text('Dr. ${globalUser.name}',style: TextStyle(color: Color(0xFF9474cc),fontSize: 30),)
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            const Text('Todays Appointments',style: TextStyle(fontSize: 23,color: Color(0xFF9474cc),fontWeight: FontWeight.w500),),
            Expanded(
              child: ListView.builder(
                itemCount: dpalist.length,
                itemBuilder: ((context, index) {
                  DocPatientApt dpa=dpalist[index];
                  String stage="";
                  if(dpa.pat.stage==0){
                    stage="Stage-I";
                  }else if(dpa.pat.stage==1){
                    stage="Stage-II";
                  }else{
                    stage="Stage-III";
                  }
                  DateTime dateTime = DateTime.parse(dpa.ap.nextAppointDate);
                  String formattedTime = DateFormat('hh:mm a').format(dateTime);
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          //   return AddAppointment(name: dpa.pat.userName,);
                          // }));
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return AppointmentDetails(name: dpa.pat.userName,);
                          }));

                        },
                        child: Row(
                          children: [
                          Container(
                          // color: Colors.amber,
                            height: MediaQuery.of(context).size.height*0.17,
                            width: MediaQuery.of(context).size.width*0.24,
                            child:  Padding(
                              padding:  const EdgeInsets.only(left: 10.0,top: 10),
                              child:  CircleAvatar(
                                radius: 5,
                                backgroundImage:MemoryImage(base64Decode(dpa.pat.profPicPath)),
                              ),
                            ),
                          ),
                          
                          Container(
                            alignment: Alignment.bottomLeft,
                            height: MediaQuery.of(context).size.height*0.17,
                            width: MediaQuery.of(context).size.width*0.61,
                            //color: Colors.cyan,
                            child: Padding(
                              padding: const EdgeInsets.only(top:48.0,left: 20),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,  
                              children: [
                                Text(dpa.pat.name,style: TextStyle(color: Color(0xFF9474cc),fontSize: 23)),
                                Text(stage,style: TextStyle(color: Color(0xFF9474cc),fontSize: 20)),
                                Padding(
                                  padding: const EdgeInsets.only(top:10.0),
                                  child: Align
                                  (
                                    alignment: Alignment.centerRight,
                                    child: Text(formattedTime,style: TextStyle(color: Color(0xFF9474cc)))
                                  ),
                                ),
                              ],),
                            ),
                            )
                        ],),
                      ),
                      horizontalLine(350),
                    ],
                  );
              })),
            )
          ],
        ),
      ),
    );
  }
}