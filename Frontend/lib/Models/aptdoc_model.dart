import 'package:flutter_application_1/allimports.dart';

class PatientAppointmentDoc{
  late Appointment appointment;
  late List<AppointmentPractice> appointmentPractices;
  late List<AppointmenTest> appointmentTests;
  late String name;

  PatientAppointmentDoc({required this.name,required this.appointment,required this.appointmentPractices,required this.appointmentTests});

  PatientAppointmentDoc.fromMap(Map<String,dynamic> map)
  {
    appointment=map["appointment"];
    name=map["name"];
    appointmentPractices=map["appointmentPractices"];
    appointmentTests=map["appointmentTests"];
  }
  Map<String,dynamic> toMap()
  {
    return{
    "name":name,
    "appointment":Appointment.map(appointment),
    "appointmentPractices":AppointmentPractice.generateMap(appointmentPractices),
    "appointmentTests":AppointmenTest.generateMap(appointmentTests),
    };
  }
}