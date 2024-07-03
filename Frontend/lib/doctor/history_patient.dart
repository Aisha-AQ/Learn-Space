import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/allimports.dart';
import 'package:intl/intl.dart';

class HistoryPatient extends StatefulWidget {
  late String name;
  final int? patientId;
   HistoryPatient({super.key,required this.name,this.patientId});

  @override
  State<HistoryPatient> createState() => _HistoryPatientState();
}

class _HistoryPatientState extends State<HistoryPatient> {
  Item? _selectedApt; // Holds the selected item
  final List<Item> dropdownDates = [];
  double maxX = 0;
  double maxY = 0;
  List<FlSpot> spots = [];
  Map<int, String> xLabels = {};
  bool isLoading = true;
  List<AppointmentData> apdata = [];
  late int pid;

  Future<void> datesList() async {
    if(widget.name!="")
    {
      Response r1=await APIHandler().patientAgainstUsername(widget.name);
      pid=jsonDecode(r1.body);
    }else if(widget.patientId!=null){
      pid=widget.patientId!;
    }else {
      Response r1=await APIHandler().checkPatientAgainstCaregiver(globalUser.id);
      if(r1.statusCode==500)
      {
        showDialog(
          context: context,
          builder:(context) => warningDialog("Warning", "Register Patient first..", context));
        return;
      }
      dynamic pa=jsonDecode(r1.body);
      Patient p=Patient.fromMap(pa);
      pid=p.pid;
    }
    
    Response response = await APIHandler().allAppointmentsDates(pid, globalUser.id);
    dynamic ulist = jsonDecode(response.body);
    if (response.statusCode == 409) {
      return;
    }
    for (int i = 0; i < ulist.length; i++) {
      dropdownDates.add(Item.fromMap(ulist[i]));
    }
    response = await APIHandler().allTestResults(pid);
    ulist = jsonDecode(response.body);
    List<FlSpot> newSpots = [];
    Map<int, String> newXLabels = {};
    for (int i = 0; i < ulist.length; i++) {
      String dateStr = ulist[i]["name"];
      DateTime date = DateFormat('M/d/yyyy').parse(dateStr); // Parse the date string
      String formattedDate = DateFormat('MM/dd').format(date);
      newXLabels[i] = formattedDate;
      newSpots.add(FlSpot(i.toDouble(), ulist[i]["Total"].toDouble()));
    }

    setState(() {
      spots = newSpots;
      xLabels = newXLabels;
      maxX = spots.length.toDouble() - 1;
      maxY = 120;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    datesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Color(0xFF9474cc)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<Item>(
                  hint: const Text('Select a date'),
                  value: _selectedApt,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (Item? newValue) async {
                    setState(() {
                      _selectedApt = newValue;
                      apdata.clear(); // Clear the previous data
                    });
                    Response response = await APIHandler().showSpecificAppointmentData(_selectedApt!.aptId, pid);
                    dynamic ulist = jsonDecode(response.body);
                    List<AppointmentData> newApdata = [];
                    if(response.body.contains("Not Any Test And Practice Assign On Particular apointment")){return;}
                    for (int i = 0; i < ulist["TestData"].length; i++) {
                      newApdata.add(AppointmentData.fromMap(ulist["TestData"][i]));
                    }
                    setState(() {
                      apdata = newApdata; // Update the state with the new data
                    });
                  },
                  items: dropdownDates.map<DropdownMenuItem<Item>>((Item item) {
                    return DropdownMenuItem<Item>(
                      value: item,
                      child: Text(item.date),
                    );
                  }).toList(),
                ),
                SizedBox(height: 30,),
                apdata.isEmpty
                    ? Container(child:Text('No data'))
                    : Center(
                        child: Container(
                          color: Colors.grey[300],
                          width: 300,
                          height: 200,
                          child: ListView.builder(
                            itemCount: apdata.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(apdata[index].eText),
                                trailing: Icon(
                                  apdata[index].feedback ? Icons.check : Icons.close,
                                  color: apdata[index].feedback ? Colors.green : Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                spots.isEmpty
                    ? Container()
                    : allTestsGraphData(spots: spots, xLabels: xLabels, maxX: maxX, maxY: maxY),
              ],
            ),
    );
  }
}

class Item {
  late int aptId;
  late String date;

  Item(this.aptId, this.date);
  Item.fromMap(Map<String, dynamic> map) {
    aptId = map["id"];
    date = map["appointmentDate"];
  }
}

class AppointmentData {
  late String eText;
  late bool feedback;

  AppointmentData(this.eText, this.feedback);
  AppointmentData.fromMap(Map<String, dynamic> map) {
    eText = map["eText"];
    feedback = map["feedback"];
  }
}

class allTestsGraphData extends StatelessWidget {
  final List<FlSpot> spots;
  final Map<int, String> xLabels;
  final double maxX;
  final double maxY;

  allTestsGraphData({required this.spots, required this.xLabels, required this.maxX, required this.maxY});

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
