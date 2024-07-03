import 'package:flutter_application_1/allimports.dart';

class AddAppointment extends StatefulWidget {
  late String name;
   AddAppointment({super.key,required this.name});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}
DateTime? _selectedDate;
TimeOfDay? _selectedTime;

class _AddAppointmentState extends State<AddAppointment> {
  
  TextEditingController name =TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.name!="")
    {
      name.text=widget.name;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customAppbarLeftDroop(MediaQuery.of(context).size.width,"Appointment",45,onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return DocHome();
          }));}),
          SizedBox(height: MediaQuery.of(context).size.height*0.03,),
          Container(
            width: MediaQuery.of(context).size.width*0.95,
            child: customTextFormField(name, "Patient Username", "Username or email")
          ),
          SizedBox(height:MediaQuery.of(context).size.height*0.02),
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
            child: AppointmentDate(),
          ),
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
            child:
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Time',style: TextStyle(color: Color(0xFF9474cc),fontSize: 25,fontWeight:FontWeight.w600)),
              ),
          ),
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07),
            child: TimePicker(),
          ),
          SizedBox(height:MediaQuery.of(context).size.height*0.02),
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
            child:
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    const Text('Add activity',style: TextStyle(color: Color(0xFF9474cc),fontSize: 24,fontWeight:FontWeight.w500)),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AssignActivity(viewOnly: false,))),
                        style: ElevatedButton.styleFrom(
                           backgroundColor: Color.fromARGB(255, 223, 197, 233),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), 
                            ),
                            elevation: 3.0, 
                          ),
                        child: Text('Add',style: TextStyle(fontSize: 13),),)
                    )
                  ],
                ),
              ),
          ),
           SizedBox(height:MediaQuery.of(context).size.height*0.02),
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
            child:
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text('Add test',style: TextStyle(color: Color(0xFF9474cc),fontSize: 24,fontWeight:FontWeight.w500)),
                    SizedBox(width: 52,),
                    Container(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AssignTest(viewOnly: false,))),
                        style: ElevatedButton.styleFrom(
                           backgroundColor: Color.fromARGB(255, 223, 197, 233),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), 
                            ),
                            elevation: 3.0, 
                          ),
                        child: Text('Add',style: TextStyle(fontSize: 13),),)
                    )
                  ],
                ),
              ),
          ),
          SizedBox(height: 40,),
          customButton('Save APPOINTMENT', ()
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
            Response r1=await APIHandler().patientAgainstUsername(name.text);
            var ulist=jsonDecode(r1.body);

            DateTime combinedDateTime = combineDateTimeAndTimeOfDay(_selectedDate!, _selectedTime!);
            DateTime date=DateTime.now();
            date=date.subtract(Duration(days: 3));
            Appointment ad=Appointment(userId: globalUser.id, patientId: ulist, feedback: "n", appointmentDate: DateTime.now().toIso8601String(), nextAppointDate: combinedDateTime.toIso8601String());
            PatientAppointmentDoc pad=PatientAppointmentDoc(name: name.text, appointment: ad, appointmentPractices: globalAppointmentPractice, appointmentTests: globalAppointmentTest);
            Response r=await APIHandler().addAppointmentDoc(pad);
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
              globalAppointmentPractice=[];
              globalAppointmentTest=[];
            }
            else if(r.statusCode==409)
            {
              showDialog(context: context, builder: (BuildContext context)=> warningDialog("Error", r.body, context));
              globalAppointmentPractice=[];
              globalAppointmentTest=[];
            }
          })
        ],
        
      
        
      ),
    );
  }
}

class AppointmentDate extends StatefulWidget {
  const AppointmentDate({super.key});

  @override
  State<AppointmentDate> createState() => _AppointmentDateState();
}

class _AppointmentDateState extends State<AppointmentDate> {
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

class TimePicker extends StatefulWidget {
  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {

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
DateTime combineDateTimeAndTimeOfDay(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}