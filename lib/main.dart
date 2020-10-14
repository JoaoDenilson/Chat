import 'package:chatpdm/helpers/firebase_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //Inicializar o FireBase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseHelper helper = FirebaseHelper();

  helper.sendMessage("Oi Ramozim.");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(),
    );
  }
}

