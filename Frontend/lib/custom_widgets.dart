import 'package:flutter/material.dart';
import 'package:flutter_application_1/allimports.dart';

Material customTextFormField(TextEditingController tc,String hinttext,String labeltext)
{
  return Material(
    elevation: 10.0,
    shadowColor: Colors.black38,
      child: TextFormField(
        controller: tc,
        style:const TextStyle(fontSize:23),
        decoration: InputDecoration(
          
          hintText: hinttext,
          hintStyle:const TextStyle(color:Color.fromARGB(173, 17, 17, 17)),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          enabledBorder: UnderlineInputBorder(
            borderRadius:BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Color.fromARGB(255, 170, 141, 221), width: 1.0,style: BorderStyle.none)
          )
      ),
    ),
  );
      
  
}
AlertDialog warningDialog(String title,String content,BuildContext con)
{
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      TextButton(onPressed: ()
      {
        Navigator.of(con).pop();
      }, 
      child: const Text('Close'),
      )
    ],
  );
}
Container horizontalLine(double? widths)
{
  return Container(
    height:1,
    width:widths,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color:const Color(0xFFdbbde7).withOpacity(0.3),
          
          spreadRadius:1,
          blurRadius:1,
          offset:const Offset(0,1)
        )
      ]
    ),
  );
}

ElevatedButton customButton(String data, Function()? onPressed)
{
  return ElevatedButton(
  onPressed: onPressed, 
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Adjust the value for roundness
    ),
    elevation: 5.0, // Adjust elevation as needed
  ),
  child: Padding(
    padding: const EdgeInsets.only(left: 30.0,right: 30),
    child: Text(data),
  ));
}

Container customAppbarLeftDroop(double? size,String text,double? funtsize, {Function()? onPressed})
{
  // ignore: sized_box_for_whitespace
  
  return Container(
  width: size,
    height: 250.0,
    child: ClipPath(
      clipper: MyClipper(),
      child: Stack(
        children:[
          Container(
            color: const Color(0xFF9474cc),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: GestureDetector(
              onTap: onPressed,
              child: const Icon(Icons.arrow_back_ios_sharp,color: Colors.white,)
            )
          ),
          Positioned(
            top: 85,
            left: 53,
            child:Text(text,style:  TextStyle(fontSize: funtsize,color: Colors.white),)
          ),
        ] 
      ),
    ),
  );

}
Container customAppbarMiddleDroop(double size,{BuildContext? context,String? text})
{
  return Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: const Color(0xFF9474cc),
              boxShadow: const [
        BoxShadow(blurRadius: 40.0)
              ],
              borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(
              size, 100.0)),
            ),
            
            child: Stack(
                fit: StackFit.expand,
                children: [
                  if(context!=null)
                  Positioned(
                    right: MediaQuery.of(context).size.width*0.85,
                    top: 50,
                    child: IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    },
                     icon: Icon(Icons.keyboard_arrow_left_sharp,size: 40,color: Colors.white60,))
                  ),
                  if(text!=null)
                    Positioned(
                      top: 85,
                      left: size*1.4,
                      child:Text(text,style:GoogleFonts.libreBaskerville(
                        fontSize: 45,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(255, 100, 20, 103).withOpacity(0.7),
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),)
                    ),
                ],),
          );
}


class MyClipper extends CustomClipper<Path> {
@override
Path getClip(Size size) {
    var path = Path();

    const minSize = 140.0;
    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();
    path.lineTo(0.0, size.height - p1Diff);

    final controlPoint = Offset(size.width * 0.4, size.height);
    final endPoint = Offset(size.width, minSize);

    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
}

@override
bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
  return false;
}
}
