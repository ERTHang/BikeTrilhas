
import 'dart:io';

import 'package:biketrilhas_modular/my_http_overrides.dart';
import 'package:flutter/material.dart';
import 'package:biketrilhas_modular/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() { 
  HttpOverrides.global = new MyHttpOverrides();
  runApp(ModularApp(module: AppModule()));
  }
