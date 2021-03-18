import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Doughnate',
        debugShowCheckedModeBanner:false,
        // theme: ThemeData(
        //   primaryColor: const Color(0xfff5f5f5),
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        home: GoogleAuth());
  }
}
