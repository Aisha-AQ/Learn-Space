import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/collection_model.dart';
import 'package:flutter_application_1/Models/practice.dart';

class ActivityCreation extends StatefulWidget {
  final List<Collection> a;
  final Practice p;
  const ActivityCreation({super.key, required this.a,required this.p});

  @override
  State<ActivityCreation> createState() => _ActivityCreationState();
}


class _ActivityCreationState extends State<ActivityCreation> {
List<Collection> modifiedList=[];
  hey(){
    modifiedList=widget.a.where((element) => element.id==widget.p.id).toList();

  }
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    hey();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.p.title),
      backgroundColor: Color(0xFF9474cc),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
         Expanded(
           child: ListView.builder(
             itemCount:modifiedList.length,
             itemBuilder: (context, index){
               Collection c=modifiedList[index];
               return Align(
                 alignment: Alignment.center,
                 child: Container(
                  width: 200,
                   height: 100,
                   decoration: BoxDecoration(
                   border: Border.all(
                     color: Color(0xFF9474cc),// Outline color
                     width: 2.0, // Outline width
                   ),
                   borderRadius: BorderRadius.circular(8.0), // Optional: border radius
                 ),
                   child: Center(
                     child: Text("English Text: "+c.eText!),
                   ),
                 ),
               );
             }
             
             ),
         ),
        ]
      ),

    );
  }
}