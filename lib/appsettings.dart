import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 450,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal:10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                  ],)
              )
            ],
          ),
          CustomPaint(
            child:Container(
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.width,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:EdgeInsets.all(20),
                child:Text(
                  "Profile", 
                  style:TextStyle(
                    fontSize: 35,
                    letterSpacing: 1.5,
                    color:Colors.blue,
                    fontWeight:FontWeight.w600
                    ),
                  ),
                 ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width:5),
                shape: BoxShape.circle,
                color:Colors.white,
                image: DecorationImage(
                    fit:BoxFit.cover,
                    image: AssetImage("assets/Doughnut.jpg")
                    )
              )
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 270, left:184),
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
                ),
              onPressed: () {},),
          ),
          ),
        ],
      ),
    );
  } 
}

class HeaderCurvedContainer extends CustomPainter {
  
  @override
  void paint(Canvas canvas, Size size){
    Paint paint = Paint()..color = Color(0xFF42A5F5);
    Path path = Path()
    ..relativeLineTo(0, 150)
    ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
    ..relativeLineTo(0, -150)
    ..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter olddelegate) => false;
}

// Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: Column(
//       children: [
//         CircleAvatar(radius: 100, child: Image(image: NetworkImage(photoURL))),
//         // input display name
//         TextFormField(
//           decoration: const InputDecoration(
//             labelText: "Name",
//             hintText: 'Enter your display name',
//           ),
//         ),
//         DropdownSearch(
//           items: [
//             "Prefer to be reimbursed (No NPO)",
//             "Amnesty International",
//             "Green Peace",
//             "Doctors Without Boarders"
//           ],
//           label: "NPO",
//           onChanged: print,
//           selectedItem: "Please Select",
//           validator: (String item) {
//             if (item == null)
//               return "Required field";
//             else if (item == "Brazil")
//               return "Invalid item";
//             else
//               return null;
//           },
//         )
//       ],
//     )));

//     // display donation ratio
//     // about team solidstate
//     // ROW ( save, cancel )
//   }
