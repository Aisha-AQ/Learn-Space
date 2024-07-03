import 'package:flutter_application_1/allimports.dart';

class RequestPatient extends StatefulWidget {
  const RequestPatient({super.key});

  @override
  State<RequestPatient> createState() => _RequestPatientState();
}

class _RequestPatientState extends State<RequestPatient> {

  List<Patient> patients=[];
  Future<void> getRequests()
  async {
    Response r=await APIHandler().patientRequests(globalUser.id);
    dynamic rlist=jsonDecode(r.body);
    for(int r=0;r<rlist.length;r++)
    {
      patients.add(Patient.fromRequestMap(rlist[r]));
    }
    setState(() {
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customAppbarLeftDroop(MediaQuery.of(context).size.width,"Requests",45,onPressed: (){Navigator.of(context).pop();}),
          const SizedBox(height: 5,),
          Expanded(child: 
          ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context,index)
            {
              Patient p=patients[index];
              List<String> parts = p.profPicPath.split('\\');
              String fileName = parts.last;
              p.profPicPath = 'Media/PatientsImages/$fileName';
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage("${APIHandler.baseUrlImage}${p.profPicPath}"),radius: 15,),
                title: Text(p.name),
                subtitle: Text("Stage: ${p.stage}"),
                trailing: ElevatedButton(onPressed: () 
                async {
                  Response r=await APIHandler().acceptPatientRequest(p.pid,globalUser.id);
                  if(r.statusCode==200)
                  {
                    showDialog(context: context, builder: (BuildContext context) {
                      return warningDialog("Success", "Request accepted", context);
                    });
                    patients.removeAt(index);
                    setState(() {
                      
                    });
                  }else{
                    showDialog(context: context, builder: (BuildContext context){
                      return warningDialog("Problem", "There was an issue on our end. Please try again.", context);
                    });
                  }
                },
                child: Text('Accept'),),
              );
            }
          ))
        ],
      ),
    );
  }
}