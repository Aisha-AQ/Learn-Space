import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:flutter_application_1/signUp/controller/views/patient_reg.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  late bool patientexists;
  bool _isLoading = false;
  late Patient p;
  Future<void> patientExists()async {
      setState(() {
        _isLoading = true;
      });
      Response rep=await APIHandler().checkPatientAgainstCaregiver(globalUser.id);
      if(rep.statusCode==200)
      {
        patientexists=true;
        dynamic pat=jsonDecode(rep.body);
        p=Patient.fromMap(pat);
      }else{
        patientexists=false;
      }
      setState(() {
        _isLoading=false;
      });
    }

    void initState() {
    // TODO: implement initState
    super.initState();
    patientExists();
  }

  @override
  Widget build(BuildContext context) {
    
    double size=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(color: Color(0xFF9474cc),icon: Icon(Icons.arrow_back), onPressed: () { Navigator.of(context).pop(); },),
      ),
      body: Center(
        child:
       // _isLoading ? CircularProgressIndicator() :Text('data')
        _isLoading ? CircularProgressIndicator() : patientexists ? Column(
          children: [
            SizedBox(height: size*0.03,),
            // Text(
            //     'Patient Details',
            //     style: TextStyle(color: Color(0xFF9474cc),fontSize: 30),
            //   ),
            CircleAvatar( radius: 90,backgroundImage: MemoryImage(base64Decode(p.profPicPath)),),
              SizedBox(height: 38),
              Text(
                'Name: ' + p.name,
               style: TextStyle(color: Color(0xFF9474cc),fontSize: 30),
              ),
              SizedBox(height: 3),
              horizontalLine(size*0.4),
              SizedBox(height: 8),
              Text(
                'Age: ' + p.age.toString(),
                style: TextStyle(color: Color(0xFF9474cc),fontSize: 30),
              ),
              SizedBox(height: 3),
              horizontalLine(size*0.4),
              SizedBox(height: 8),
              Text(
                'Gender: ' + p.gender,
                style: TextStyle(color: Color(0xFF9474cc),fontSize: 30),
              ),
              SizedBox(height: 3),
              horizontalLine(size*0.4),
              SizedBox(height: 10),
              BarcodeGenerator()
          ],
        ) : ElevatedButton(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PatientSignUp()),
              );
        }, child: Text('Register Patient')
        )
      )
    );
  }
}

class BarcodeGenerator extends StatelessWidget {
  const BarcodeGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: globalUser.username, // Replace with your data
              width: 100,
              height: 100,
            ),
            SizedBox(height: 10),
            Text(
              'Login Patient By Scanning',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      );
  }
}