import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/app/app.dart';
import 'core/app/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // TODO: Add Firebase initialization when Firebase is configured
  // await Firebase.initializeApp();

  // Initialize dependency injection
  configureDependencies();

  runApp(const App());
}
