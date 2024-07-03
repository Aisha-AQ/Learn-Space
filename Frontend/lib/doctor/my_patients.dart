import 'package:flutter_application_1/allimports.dart';

class MyPatients extends StatefulWidget {
  const MyPatients({super.key});

  @override
  State<MyPatients> createState() => _MyPatientsState();
}

class _MyPatientsState extends State<MyPatients> {
  List<Patient> plist=[];
  Future<void> MyPatientsList()
  async {
    Response r=await APIHandler().myPatients(globalUser.id);
    dynamic ulist=jsonDecode(r.body);
    for(int p=0;p<ulist.length;p++)
    {
      plist.add(Patient.fromMyPatientsMap(ulist[p]));
    }
    setState(() {
      
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyPatientsList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Patients'),
        leading: IconButton(icon:  const Icon(Icons.arrow_back_ios_sharp,color: Color(0xFF9474cc),), onPressed: () { Navigator.of(context).pop(); },),
      ),
      body: ListView.builder(
        itemCount: plist.length,
        itemBuilder: (context,index)
        {
          Patient p=plist[index];
          List<String> parts = p.profPicPath.split('\\');
          String fileName = parts.last;
          String imageUrl = 'Media/PatientsImages/$fileName';
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return HistoryPatient(name: "",patientId: p.pid,);
              }));
            },
            child: ListTile(
              isThreeLine: true,
              leading: SizedBox(
                height: 80,
                width: 80,
                child: Image.network("${APIHandler.baseUrlImage}${imageUrl}")),
                title: Text(p.name),
                subtitle: Text(''),
                trailing: Text('>',style: TextStyle(fontWeight: FontWeight.w900),),
            ),
          );
        }),
    );
  }
}