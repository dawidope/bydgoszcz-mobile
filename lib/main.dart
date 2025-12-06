import 'package:bydgoszcz/di/injector.dart';
import 'package:bydgoszcz/presentation/app/bydgoszcz_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Injector().setup();

  runApp(const BydgoszczApp());
}
