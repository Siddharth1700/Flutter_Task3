import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase/linkfirebase.dart';

// ignore: non_constant_identifier_names
MyApp() {
  return MyApplication();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}
