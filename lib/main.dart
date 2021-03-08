import 'package:doughnate/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
          title: 'Doughnate',
          theme: ThemeData(
            primaryColor: const Color(0xfff5f5f5),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: GoogleAuth()),
    );
  }
}
