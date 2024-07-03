import 'package:flutter_application_1/allimports.dart';

class PatientAppointment{
  late Appointment appointment;
  late List<AppointmentPractice> appointmentPractices;
  late List<AppointmenTest> appointmentTests;

  PatientAppointment({required this.appointment,required this.appointmentPractices,required this.appointmentTests});

  PatientAppointment.fromMap(Map<String,dynamic> map)
  {
    appointment=map["appointment"];
    appointmentPractices=map["appointmentPractices"];
    appointmentTests=map["appointmentTests"];
  }
  Map<String,dynamic> toMap()
  {
    return{
    "appointment":Appointment.map(appointment),
    "appointmentPractices":AppointmentPractice.generateMap(appointmentPractices),
    "appointmentTests":AppointmenTest.generateMap(appointmentTests),
    };
  }
}