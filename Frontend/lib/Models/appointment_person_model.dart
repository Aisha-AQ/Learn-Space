import 'package:flutter_application_1/Models/appointment_person_practice.dart';
import 'package:flutter_application_1/Models/appointment_person_test.dart';
import 'package:flutter_application_1/allimports.dart';

class PersonAppointment{
  late Appointment appointment;
  late List<AppointmenPersonPractice> AppoointmentPersonPractice;
  late List<AppointmenPersonTest> AppoointmentPersonTest;

  PersonAppointment({required this.appointment,required this.AppoointmentPersonPractice,required this.AppoointmentPersonTest});

  PersonAppointment.fromMap(Map<String,dynamic> map)
  {
    appointment=map["appointment"];
    AppoointmentPersonPractice=map["AppointmentPersonPractice"];
    AppoointmentPersonTest=map["AppointmentPersonTest"];
  }
  Map<String,dynamic> toMap()
  {
    return{
    "appointment":Appointment.map(appointment),
    "AppointmentPersonPractice":AppointmenPersonPractice.generateMap(AppoointmentPersonPractice),
    "AppointmentPersonTest":AppointmenPersonTest.generateMap(AppoointmentPersonTest),
    };
  }
}