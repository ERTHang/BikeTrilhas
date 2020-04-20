import 'package:biketrilhas_modular/app/modules/photo/photo_controller.dart';
import 'package:biketrilhas_modular/app/pages/display/display_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_page.dart';
import 'package:biketrilhas_modular/app/pages/display/display_page.dart';
import 'package:biketrilhas_modular/app/pages/error/error_controller.dart';
import 'package:biketrilhas_modular/app/pages/error/error_page.dart';
import 'package:biketrilhas_modular/app/pages/camera_loader/camera_loader_controller.dart';
import 'package:biketrilhas_modular/app/app_controller.dart';
import 'package:biketrilhas_modular/app/modules/login/login_module.dart';
import 'package:biketrilhas_modular/app/modules/map/map_module.dart';
import 'package:biketrilhas_modular/app/pages/camera_loader/camera_loader_page.dart';
import 'package:biketrilhas_modular/app/pages/splash/splash_page.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository.dart';
import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:biketrilhas_modular/app/app_widget.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => DisplayController()),
        Bind((i) => ErrorController()),
        Bind((i) => CameraLoaderController()),
        Bind((i) => AppController()),
        Bind<IAuthRepository>((i) => AuthRepository()),
        Bind((i) => AuthController()),
        Bind((i) => PhotoController()),
      ];

  @override
  List<Router> get routers => [
        Router('/', child: (_, args) => SplashPage()),
        Router('/login',
            module: LoginModule(), transition: TransitionType.noTransition),
        Router('/map', module: MapModule(), transition: TransitionType.noTransition),
        Router('/loader', child: (_, args) => CameraLoaderPage()),
        Router('/error', child: (_, args) => ErrorPage()),
        Router('/camera', child: (_, args) => PhotoPage(camera: args.data)),
        Router('/display', child: (_, args) => DisplayPage(imagePath: args.data))
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
