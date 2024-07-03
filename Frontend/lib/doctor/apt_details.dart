import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:intl/intl.dart';

class AppointmentDetails extends StatefulWidget {
  late String name;
  AppointmentDetails({super.key,required this.name});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

late double maxX;
late double maxY;
List<FlSpot> spots = [];
DateTime? _selectedDate;
TimeOfDay? _selectedTime;
Map<int, String> xLabels = {};


class _AppointmentDetailsState extends State<AppointmentDetails> {
  bool isLoading = true;
  List<dynamic>? test;
  List<dynamic>? practices;
  bool _isRepeatedChecked = false;
  Future<void> result() async {
    setState(() {
      isLoading = true;
    });
    spots=[];
    xLabels={};
    Response r1=await APIHandler().patientAgainstUsername(widget.name);
    var pid=jsonDecode(r1.body);
    var response = await APIHandler().testResults(pid, globalUser.id);
    dynamic ulist = jsonDecode(response.body);

    for (int i = 0; i < ulist.length; i++) {
      String dateStr = ulist[i]["name"];
      DateTime date = DateFormat('M/d/yyyy').parse(dateStr);  // Parse the date string
      String formattedDate = DateFormat('MM/dd').format(date);
      xLabels[i] = formattedDate;
      spots.add(FlSpot(i.toDouble(), ulist[i]["Total"].toDouble()));
    }

    maxX = spots.length.toDouble() - 1;
    maxY = 120; // Set maxY to 120 as per your requirement

    response = await APIHandler().assignedTestsandPractices(globalUser.id, pid);
    ulist = jsonDecode(response.body);
    test = ulist["tests"];
    practices = ulist["practices"];

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    result();
  }

  double _calculateDynamicHeight(int itemCount) {
    double itemHeight = 60.0; // Fixed height for each item
    return itemCount * itemHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment Details')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : GraphData(spots: spots, xLabels: xLabels, maxX: maxX, maxY: maxY),
            const Align(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Practices:', style: TextStyle(color: Color(0xFF9474cc), fontSize: 25, fontWeight: FontWeight.w500)),
                )),
            practices != null
                ? Container(
                    height: _calculateDynamicHeight(practices!.length),
                    child: ListView.builder(
                      itemCount: practices!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('  ${index + 1}.  ${practices![index]['title']}'),
                        );
                      },
                    ),
                  )
                : Container(),
            const Align(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Tests:', style: TextStyle(color: Color(0xFF9474cc), fontSize: 25, fontWeight: FontWeight.w500)),
                )),
            test != null
                ? Container(
                    height: _calculateDynamicHeight(test!.length),
                    child: ListView.builder(
                      itemCount: test!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('  ${index + 1}.  ${test![index]['title']}'),
                        );
                      },
                    ),
                  )
                : Container(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return HistoryPatient(name: widget.name,);
                  }));
                }, child: Text('More History >'))),
            Row(
                children: [
                  Checkbox(
                    value: _isRepeatedChecked,
                    onChanged: (bool? newValue) {
                    setState(() {
                      _isRepeatedChecked = newValue ?? false;
                    });
                  },),
                  
                  Text('Repeat',style: TextStyle(fontSize: 18),)
                ],
              ),  
              Padding(
              padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
              child:
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Date',style: TextStyle(color: Color(0xFF9474cc),fontSize: 25,fontWeight:FontWeight.w600)),
                  ),
              ),
              Padding(
                padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07),
                child: AppointmentDetailDate(),
              ),
              Padding(
                padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                child:
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Time',style: TextStyle(color: Color(0xFF9474cc),fontSize: 25,fontWeight:FontWeight.w600)),
                  ),
              ),  
              Padding(
                padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07),
                child: TimePickerApt(),
              ),
              SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: ()
              async {
                if(_selectedDate==null)
                {
                  showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Please Select a date for next appointment", context));
                  return;
                }
                if(_selectedTime==null)
                {
                  showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Please Select a time for next appointment", context));
                  return;
                }
                if(_isRepeatedChecked)
                {
                  Response r1=await APIHandler().patientAgainstUsername(widget.name);
                  var pid=jsonDecode(r1.body);
                  DateTime combinedDateTime = combineDateTimeAndTimeOfDay(_selectedDate!, _selectedTime!);
                  Response r=await APIHandler().previousDoctorAppointment(globalUser.id, pid);
                  dynamic ulist = jsonDecode(r.body);
                  List<AppointmentPractice> aplist=[];
                  for(int i=0;i<ulist["practices"].length;i++)
                  {
                    AppointmentPractice ap=AppointmentPractice(appointmentId: -1, practiceId: -1);
                    ap.practiceId=ulist["practices"][i]["id"];
                    aplist.add(ap);
                  }
                  List<AppointmenTest> atlist = [];
                  for (int i = 0; i < ulist["tests"].length; i++) {
                      AppointmenTest ap = AppointmenTest(appointmentId: -1, testId: -1);
                      ap.testId = ulist["tests"][i]["id"];
                      atlist.add(ap);
                  }
                  
                  Appointment ad=Appointment(userId: globalUser.id, patientId: pid, feedback: "n", appointmentDate: DateTime.now().toIso8601String(), nextAppointDate: combinedDateTime.toIso8601String());
                  PatientAppointmentDoc pad=PatientAppointmentDoc(name: widget.name, appointment: ad, appointmentPractices: aplist, appointmentTests: atlist);
                  r=await APIHandler().addAppointmentDoc(pad);
                  if(r.statusCode==404)
                  {
                    showDialog(context: context, builder: (BuildContext context)=> warningDialog("Warning", "Patient username is incorrect.", context));
                  }else if(r.statusCode==500)
                  {
                    showDialog(context: context, builder: (BuildContext context)=> warningDialog("Error", "We\'ve encoutered a problem.\nPlease try again.", context));
                  }
                  else if(r.statusCode==200)
                  {
                    showDialog(context: context, builder: (BuildContext context)=> warningDialog("Success", "Appointment added successfully.", context));
                    
                  }
                  else if(r.statusCode==409)
                  {
                    showDialog(context: context, builder: (BuildContext context)=> warningDialog("Error", r.body, context));
                    
                  }
                }
              }, child: Text('Save Appointment')),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return AddAppointment(name: widget.name);
                }));}, child: Text('New Appointment')),
              
            ],
          ),
          SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

class GraphData extends StatelessWidget {
  final List<FlSpot> spots;
  final Map<int, String> xLabels;
  final double maxX;
  final double maxY;

  GraphData({required this.spots, required this.xLabels, required this.maxX, required this.maxY});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20, // Set the interval to 20
                  getTitlesWidget: (value, meta) {
                    // Show only numbers with increments of 20
                    return Text('${value.toInt()}', style: TextStyle(color: Colors.black, fontSize: 10));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < xLabels.length) {
                      return Text(
                        xLabels[index]!,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: const Color(0xff37434d),
              ),
            ),
            minX: 0,
            maxX: maxX,
            minY: 0,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class AppointmentDetailDate extends StatefulWidget {
  const AppointmentDetailDate({super.key});

  @override
  State<AppointmentDetailDate> createState() => _AppointmentDetailDateState();
}

class _AppointmentDetailDateState extends State<AppointmentDetailDate> {
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

class TimePickerApt extends StatefulWidget {
  @override
  State<TimePickerApt> createState() => _TimePickerAptState();
}

class _TimePickerAptState extends State<TimePickerApt> {

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
          children: <Widget>[
            
            IconButton(
          icon: const Icon(Icons.calendar_today,color: Color.fromARGB(255, 120, 84, 181),),
          onPressed: () async {
             _selectTime(context);
             setState(() {
               
             });
          },
        ),
            
            SizedBox(height: 20),
            Text(
              _selectedTime != null
                ?'${_selectedTime!.format(context)}'
                :'No time selected',
              style: TextStyle(fontSize: 20),
            ),
          ],
        );
      
  }
}
DateTime combineDateTimeAndTimeOfDay2(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}