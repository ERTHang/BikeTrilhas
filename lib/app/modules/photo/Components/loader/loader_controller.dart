import 'package:camera/camera.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'loader_controller.g.dart';

class LoaderController = _LoaderControllerBase with _$LoaderController;

abstract class _LoaderControllerBase with Store {}
