import 'package:flutter_application_1/allimports.dart';
import 'package:flutter_application_1/caregiver/sentence.dart';
import 'package:flutter_application_1/caregiver/two_person_test.dart';
import 'package:flutter_application_1/patient/person_recognition_2.dart';
import 'package:flutter_application_1/signUp/controller/views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: PersonRecognition2()
    );
  }
}
