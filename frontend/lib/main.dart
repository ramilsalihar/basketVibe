import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:basketvibe/core/app/app.dart';
import 'package:basketvibe/core/network/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  // Initialize dependency injection (async for SharedPreferences)
  await configureDependencies();

  runApp(const App());

  // Updates
}
