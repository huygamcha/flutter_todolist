// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:my_app/Services/Auth_Service.dart';
import 'package:my_app/pages/HomePage.dart';
import 'package:my_app/pages/PhoneAuth.dart';
import 'package:my_app/pages/SignUpPage.dart';
import 'package:my_app/pages/SignInPage.dart';
import 'package:my_app/pages/AddPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Customize Firebase initialization with options if needed
  // FirebaseOptions firebaseOptions = const FirebaseOptions(
  //   apiKey: "your_api_key",
  //   appId: "your_app_id",
  //   messagingSenderId: "your_messaging_sender_id",
  //   projectId: "your_project_id",
  // );

  // await Firebase.initializeApp(options: firebaseOptions);
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  // void signup() async {
  //   try {
  //     await firebaseAuth.createUserWithEmailAndPassword(
  //         email: 'lehuynhhuy2002@gmail.com', password: '123456');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Widget currentPage = SignInPage();
  Authclass authclass = Authclass();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await authclass.getToken();
    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: currentPage);
  }
}
