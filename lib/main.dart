import 'package:flutter/material.dart';
import 'package:basketvibe/core/app/app.dart';
import 'package:basketvibe/core/app/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection (async for SharedPreferences)
  await configureDependencies();

  runApp(const App());
}
