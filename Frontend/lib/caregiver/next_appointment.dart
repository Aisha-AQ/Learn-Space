import 'package:flutter_application_1/allimports.dart';




class NextAppointmentCard extends StatefulWidget {
  

  NextAppointmentCard();

  @override
  _NextAppointmentCardState createState() => _NextAppointmentCardState();
}

class _NextAppointmentCardState extends State<NextAppointmentCard> {
  late String dt;
  late String name;
  late String formattedDate;
  late String formattedTime;
  bool noData=false;
  bool _isLoading = true;
  Future<void> callApi()
  async {
    Response r1=await APIHandler().checkPatientAgainstCaregiver(globalUser.id);
    if(r1.statusCode==500)
    {
      showDialog(
        context: context,
        builder:(context) => warningDialog("Warning", "Register Patient first..", context));
      return;
    }
    dynamic pat=jsonDecode(r1.body);
    Patient p=Patient.fromMap(pat);
    Response response=await APIHandler().nextAppointmet(p.pid);
    dynamic ulist=jsonDecode(response.body);
    if(ulist!=null)
    {
      Map<String,dynamic> map=ulist;
        dt=map["nextAppointDate"];
        name=map["name"];
        DateTime dateTime = DateTime.parse(dt);
        
        var date = DateTime.parse("2019-04-16 12:18:06.018950");
        formattedDate = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
      formattedTime = "${dateTime.hour}:${dateTime.minute}";
      _isLoading=false;
        setState(() {
          
        });
    }else{
      noData=true;
      _isLoading=false;
        setState(() {
          
        });
    }
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customAppbarLeftDroop(400, "Appointment", 20,onPressed: (){Navigator.of(context).pop();}),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator()):
                  noData?Center(child: Text('No Scheduled Appointment'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Color(0xFF9474cc)),
                            SizedBox(width: 10),
                            Text(
                              formattedDate,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Color(0xFF9474cc)),
                            SizedBox(width: 10),
                            Text(
                              formattedTime,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.person, color: Color(0xFF9474cc)),
                            SizedBox(width: 10),
                            Text(
                              'Dr. $name',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Navigate to appointment details or perform any action
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.check_circle),
                            label: Text('Confirm'),
                            style: ElevatedButton.styleFrom(
                              // primary: Color(0xFF9474cc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
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