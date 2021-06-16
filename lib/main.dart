import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:biketrilhas_modular/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/app_widget.dart';
import 'app/shared/info/save_trilha.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getPref();
  runApp(ModularApp(
    child: AppWidget(),
    module: AppModule(),
  ));
}
