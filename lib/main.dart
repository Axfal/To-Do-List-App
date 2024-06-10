// ignore_for_file: prefer_const_constructors

import 'package:firebase/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCViLF12QBh6oRabhrwygIorYM4ukaLkuE",
        authDomain: "testing-cli-a9f78.firebaseapp.com",
        databaseURL: "https://testing-cli-a9f78-default-rtdb.firebaseio.com",
        projectId: "testing-cli-a9f78",
        storageBucket: "testing-cli-a9f78.appspot.com",
        messagingSenderId: "357749336399",
        appId: "1:357749336399:web:78e96201950ff1a012bd3a",
        measurementId: "G-3Z5PXVVWHJ"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
          primarySwatch: Colors.deepPurple),
      home: SplashScreen(),
    );
  }
}
