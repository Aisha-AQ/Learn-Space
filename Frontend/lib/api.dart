import 'package:flutter_application_1/allimports.dart';
import 'package:flutter_application_1/caregiver/two_person_test.dart';
import 'package:flutter_application_1/patient/person_test.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
class APIHandler
{
  String baseUrl='http://192.168.43.68/LearnSpaceApi/api/';
  static String baseUrlImage='http://192.168.43.68/LearnSpaceApi/';
  Future<http.Response> activityList(int uid)async
  {
    
    String url="${baseUrl}Practice/userDefindPractices?Uid=${uid}";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> allAppointmentsDates(int pid,int uid)async
  {
    
    String url="${baseUrl}Person/GetAllAppointmentsDates?pid=$pid&uid=$uid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> assignActivity(var pa)async
  {
    dynamic d=pa.toMap();
    String url="${baseUrl}User/addAppointment";
    Uri uri=Uri.parse(url);
    var json= jsonEncode(d);
    Uint8List u=utf8.encode(json);
    var response = await http.post(uri,body: u,
    headers: {
      "Content-Type":"application/json; charset=UTF8"
    }
    );
    return response;
  }
  Future<http.Response> addAppointmentDoc(PatientAppointmentDoc pa)async
  {
    
    dynamic d=pa.toMap();
    String url="${baseUrl}Practice/addAppointmentDoctor";
    Uri uri=Uri.parse(url);
    var json= jsonEncode(d);
    Uint8List u=utf8.encode(json);
    var response = await http.post(uri,body: u,
    headers: {
      "Content-Type":"application/json; charset=UTF8"
    }
    );
    return response;
  }
  Future<http.Response> login(String email,String password,String type)async
  {
    
    String url="${baseUrl}User/SignIn?username=$email&password=$password&type=$type";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> testResults(int pid, int did)async
  {
    
    String url="${baseUrl}User/specificTestResults?pid=$pid&did=$did";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> allTestResults(int pid)async
  {
    
    String url="${baseUrl}User/GetAllTestResults?pid=$pid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> loginPatient(String email,String password)async
  {
    
    String url="${baseUrl}User/SignInPatient?username=$email&password=$password";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> allDoctorsList()async
  {
    
    String url="${baseUrl}User/allDoctors";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> facialRecognition(String img)async
  {
    
    String url="${baseUrl}Person/Upload";
    Uri uri=Uri.parse(url);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    http.MultipartFile audiofile=await http.MultipartFile.fromPath("personPic", img);
    request.files.add(audiofile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;

  }
  Future<http.Response> facialRecognition2(String img,String name)async
  {
    
    String url="${baseUrl}Person/Upload2";
    Uri uri=Uri.parse(url);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    request.fields["name"]=name;
    http.MultipartFile audiofile=await http.MultipartFile.fromPath("personPic", img);
    request.files.add(audiofile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;

  }

  Future<void> uploadImages(List<File> images) async {
    String url = "${baseUrl}Person/multipleFile";
    Uri uri = Uri.parse(url);
    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    for (var image in images) {
      String fileName = image.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath('personPics', image.path, filename: fileName));
    }

    var response = await request.send();

    // Handle response
    if (response.statusCode == 200) {
      print('Images uploaded successfully');
      // Perform any success actions
    } else {
      print('Failed to upload images. Status code: ${response.statusCode}');
      // Perform error handling
    }
  }
  Future<http.Response> nextAppointmet(int pid)async
  {
    String url="${baseUrl}User/NextVisit?pid=$pid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  Future<http.Response> allCollections(String type)async
  {
    String url="${baseUrl}Collection/allCollections?type=$type";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<int> addCustomPractice(dynamic obj)async
  {
    String url="${baseUrl}Practice/AddNewPractice";
    
    var json= jsonEncode(obj);
    
    Uri uri=Uri.parse(url);
    var response =await  http.post(uri,body: utf8.encode(json),
    headers: {
      "Content-Type":"application/json; charset=UTF8"
    }
    );
    return response.statusCode;

  }
  Future<int> addCustomPersonPractice(dynamic obj)async
  {
    String url="${baseUrl}Person/Addpractice";
    
    var json= jsonEncode(obj);
    
    Uri uri=Uri.parse(url);
    var response =await  http.post(uri,body: utf8.encode(json),
    headers: {
      "Content-Type":"application/json; charset=UTF8"
    }
    );
    return response.statusCode;

  }
  Future<int> computeTestResult(List<TestResultComputation> assignTestData) async {
    final url = Uri.parse('${baseUrl}User/TestComputation');
    final headers = {"Content-Type": "application/json; charset=UTF-8"};

    try {
      final List<Map<String, dynamic>> jsonList =
      assignTestData.map((data) => data.toJson()).toList();
      final body = jsonEncode(jsonList);

      final response = await http.post(url, body: body, headers: headers);
print(response.body);
      return response.statusCode;
    } catch (e) {
      print("Error: $e");
      return -1; // Return a custom error code or handle error as needed
    }
  }
    Future<http.Response> computePersonTestResult(List<TestResultComputation1> assignTestData) async {
    final url = Uri.parse('${baseUrl}Person/TestComputation');
    final headers = {"Content-Type": "application/json; charset=UTF-8"};

      final List<Map<String, dynamic>> jsonList =
      assignTestData.map((data) => data.toJson()).toList();
      final body = jsonEncode(jsonList);

      final response = await http.post(url, body: body, headers: headers);

      return response;
  }
  Future<int> uploadperson(String name,String gender,String age,String relation,String audio,int addBy,String imgpath,int forceAdd)async
  {
    String url="${baseUrl}Person/UploadPersonData?forceAdd=$forceAdd";
    Uri uri=Uri.parse(url);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    request.fields["name"]=name;
    request.fields["gender"]=gender;
    request.fields["age"]=age;
    request.fields["relation"]=relation;
    request.fields["addBy"]=addBy.toString();
    http.MultipartFile audiofile=await http.MultipartFile.fromPath("audio", audio);
    http.MultipartFile imgfile=await http.MultipartFile.fromPath("picture", imgpath);
    request.files.add(audiofile);
    request.files.add(imgfile);
    
   var response= await request.send();
   return response.statusCode;
  } 
  Future<StreamedResponse> uploadCollection(String type,String eText,String uText,String group,String audio,String imgpath)async
  {
    String url="${baseUrl}Collection/AddColletion";
    Uri uri=Uri.parse(url);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    request.fields["utext"]=uText;
    request.fields["etext"]=eText;
    request.fields["type"]=type;
    request.fields["group"]=group;
    http.MultipartFile audiofile=await http.MultipartFile.fromPath("audio", audio);
    http.MultipartFile imgfile=await http.MultipartFile.fromPath("picture", imgpath);
    request.files.add(audiofile);
    request.files.add(imgfile);
    
   var response= await request.send();
   return response;
  } 
  Future<http.Response> uploadMultipleFiles(List<File> files) async {
    String url = "${baseUrl}YourEndpoint";
    Uri uri = Uri.parse(url);

    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    for (File file in files) {
      String fileName = basename(file.path);
      request.files.add(await http.MultipartFile.fromPath('personPics', file.path, filename: fileName));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }
    Future<http.Response> uploadMultipleFiles2(
      String name, String gender, int age, String relation, File audio, int addBy, List<File> personPics) async {
    String url = "${baseUrl}UploadPersonData";
    Uri uri = Uri.parse(url);

    var request = http.MultipartRequest('POST', uri);

    // Add form fields
    request.fields['name'] = name;
    request.fields['gender'] = gender;
    request.fields['age'] = age.toString();
    request.fields['relation'] = relation;
    request.fields['addBy'] = addBy.toString();

    // Add audio file
    if (audio != null) {
      request.files.add(await http.MultipartFile.fromPath('audio', audio.path, filename: basename(audio.path)));
    }

    // Add person pictures
    for (File pic in personPics) {
      request.files.add(await http.MultipartFile.fromPath('personPics', pic.path, filename: basename(pic.path)));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<http.Response> assignedTestsandPractices(int did,int pid)async
  {
    
    String url="${baseUrl}User/showSpacificAppointmentData1?did=$did&pid=$pid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> showSpecificAppointmentData(int appointmentId,int pid)async
  {
    
    String url="${baseUrl}User/showSpacificAppointmentData?AppointmentId=$appointmentId&pid=$pid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> previousDoctorAppointment(int did,int pid)async
  {
    
    String url="${baseUrl}User/previousDoctorAppointment?did=$did&pid=$pid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  //Person
  Future<http.Response> allPerson(int id)async
  {
    String url="${baseUrl}Person/Getpersons?CaregiverId=$id";
    Uri uri=Uri.parse(url);
    var response =await http.get(uri);
    return response;
  }
  Future<http.Response> personPractices(int id)async
  {
    String url="${baseUrl}Person/GetPersonpractice?uid=$id";
    Uri uri=Uri.parse(url);
    var response =await http.get(uri);
    return response;
  }
  Future<int> registerUser(String name,String username,String type,String password,String imgpath)async
  {
    String url="${baseUrl}User/SignUp";
    Uri uri=Uri.parse(url);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    request.fields["name"]=name;
    request.fields["username"]=username;
    request.fields["type"]=type;
    request.fields["password"]=password;
    http.MultipartFile imgfile=await http.MultipartFile.fromPath("profilePic", imgpath);
    request.files.add(imgfile);
    
   var response= await request.send();
   return response.statusCode;
  } 
  Future<int> addSentence(String sentence)async
  {
    String url="${baseUrl}User/addSentence";
    Uri uri=Uri.parse(url);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    request.fields["sentence"]=sentence;
   var response= await request.send();
   return response.statusCode;
  } 
  Future<int> registerPatient(String name,String age,String gender,String username,String password,String imgpath,String doctorId)async
  {
    String url="${baseUrl}User/CaregiverRegisterPatient";
    Uri uri=Uri.parse(url);
    http.MultipartRequest request=http.MultipartRequest('POST',uri);
    request.fields["name"]=name;
    request.fields["username"]=username;
    request.fields["gender"]=gender;
    request.fields["age"]=age;
    request.fields["password"]=password;
    request.fields["caregiverId"]=globalUser.id.toString();
    request.fields["DoctorId"]=doctorId;
    http.MultipartFile imgfile=await http.MultipartFile.fromPath("profpic", imgpath);
    request.files.add(imgfile);
    
   var response= await request.send();
   return response.statusCode;
  } 
  Future<http.Response> uploadTest(TestCollection testCollection) async
  {
    String url="${baseUrl}xy/AddNewTest";
    Uri uri=Uri.parse(url);
    dynamic x=testCollection.toMap();
    var json=jsonEncode(x);
    var response=await http.post(uri,body: json,
    headers: {
      "Content-Type":"application/json; charset=UTF-8"
    }
    );
    return response;
  }
  Future<http.Response> uploadPersonTest(TestPersonCollection testCollection) async
  {
    String url="${baseUrl}Person/AddPersonTest";
    Uri uri=Uri.parse(url);
    dynamic x=testCollection.toMap();
    var json=jsonEncode(x);
    var response=await http.post(uri,body: json,
    headers: {
      "Content-Type":"application/json; charset=UTF-8"
    }
    );
    return response;
  }
  Future<http.Response> uploadTwoPersonTest(TwoTestPersonCollection testCollection) async
  {
    String url="${baseUrl}Person/AddTwoPersonTest";
    Uri uri=Uri.parse(url);
    dynamic x=testCollection.toMap();
    var json=jsonEncode(x);
    print(x);
    var response=await http.post(uri,body: json,
    headers: {
      "Content-Type":"application/json; charset=UTF-8"
    }
    );
    return response;
  }
  Future<http.Response> testList(int uid)async
  {
    
    String url="${baseUrl}Test/userDefindTest?Uid=$uid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> personTestList(int uid)async
  {
    
    String url="${baseUrl}Person/GetPersonTest?uid=$uid";
    Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> assisgnedTestList(int pid,DateTime date)async
  {
    
    String url="${baseUrl}Test/userDefindTest1?pid=$pid&date=$date";
    Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> patientRequests(int uid)async
  {
    
    String url="${baseUrl}User/allPatientRequest?uid=$uid";
    Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> acceptPatientRequest(int pid,int uid)async
  {
    
    String url="${baseUrl}User/AcceptPatientRequest?pid=$pid&uid=$uid";
    Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;

  }
  Future<http.Response> checkPatientAgainstCaregiver(int cgId)async
  {
    String url="${baseUrl}User/checkPatientAgainstCaregiver?cgId=$cgId";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  Future<http.Response> checkCaregiverAgainstPatient(int pId)async
  {
    String url="${baseUrl}User/checkCaregiverAgainstPatient?pId=$pId";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  Future<http.Response> getAppointments(int uid,DateTime dt)async
  {
    String url="${baseUrl}User/GetAppointments?Did=$uid&date=$dt";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  Future<http.Response> myPatients(int uid)async
  {
    String url="${baseUrl}User/GetAllpatiets?Did=$uid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  //Patient
  Future<http.Response> patientPractices(int Pid,DateTime date)async
  {
    String url="${baseUrl}User/AssignedPractice?Pid=$Pid&date=$date";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  Future<http.Response> patientTests(int pid)async
  {
    String url="${baseUrl}User/AssignedTest?Pid=$pid&filter=all";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  Future<http.Response> personTests(int pid)async
  {
    String url="${baseUrl}Person/GetAssignPersonTest?Pid=$pid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  Future<http.Response> assignedPersonPractices(int pid)async
  {
    String url="${baseUrl}Person/GetAssignPersonPractice?Pid=$pid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }
  Future<http.Response> patientAgainstUsername(String pid)async
  {
    String url="${baseUrl}User/patientAgainstUsername?p=$pid";
     Uri uri=Uri.parse(url);
    var response =await  http.get(uri);
    return response;
  }

}

