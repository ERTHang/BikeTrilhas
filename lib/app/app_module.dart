import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_module.dart';
import 'package:biketrilhas_modular/app/app_controller.dart';
import 'package:biketrilhas_modular/app/modules/login/login_module.dart';
import 'package:biketrilhas_modular/app/modules/map/map_module.dart';
import 'package:biketrilhas_modular/app/modules/search/search_module.dart';
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
        Bind((i) => DrawerClassController()),
        Bind((i) => AppController()),
        Bind<IAuthRepository>((i) => AuthRepository()),
        Bind((i) => AuthController()),
      ];

  @override
  List<Router> get routers => [
        Router('/', child: (_, args) => SplashPage()),
        Router('/login',
            module: LoginModule(), transition: TransitionType.noTransition),
        Router('/map',
            module: MapModule(), transition: TransitionType.noTransition),
        Router('/photo', module: PhotoModule()),
        Router('/search', module: SearchModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
