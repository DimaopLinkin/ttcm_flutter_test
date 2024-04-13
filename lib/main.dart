import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ttcm_flutter_test/injection.dart';
import 'package:ttcm_flutter_test/presentation/application.dart';

void main() async {
  configureDependencies();

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const Application());
}
