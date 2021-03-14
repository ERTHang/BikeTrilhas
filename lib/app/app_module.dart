import 'package:biketrilhas_modular/app/modules/filter/filter_module.dart';
import 'package:biketrilhas_modular/app/modules/info/info_module.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_module.dart';
import 'package:biketrilhas_modular/app/modules/waypoints/waypoints_module.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_module.dart';
import 'package:biketrilhas_modular/app/app_controller.dart';
import 'package:biketrilhas_modular/app/modules/login/login_module.dart';
import 'package:biketrilhas_modular/app/modules/map/map_module.dart';
import 'package:biketrilhas_modular/app/pages/splash/splash_page.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository.dart';
import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository_interface.dart';
import 'package:biketrilhas_modular/app/shared/filter/filter_repository.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/storage/shared_prefs.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:biketrilhas_modular/app/app_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => DrawerClassController()),
        Bind((i) => AppController()),
        Bind((i) => MapController(i.get(), i.get(), i.get())),
        Bind<IAuthRepository>((i) => AuthRepository()),
        Bind((i) => AuthController()),
        Bind((i) => InfoRepository(i.get<Dio>())),
        Bind((i) => TrilhaRepository(i.get<Dio>(), i.get<SharedPrefs>())),
        Bind((i) => FilterRepository(i.get<Dio>())),
        Bind((i) => SharedPrefs()),
        Bind((i) => Dio(BaseOptions(baseUrl: URL_BASE)))
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', child: (_, args) => SplashPage()),
        ModularRouter('/login',
            module: LoginModule(), transition: TransitionType.noTransition),
        ModularRouter('/map',
            module: MapModule(), transition: TransitionType.noTransition),
        ModularRouter('/photo', module: PhotoModule()),
        ModularRouter('/usertrail', module: UsertrailsModule()),
        ModularRouter('/waypoint', module: WaypointsModule()),
        ModularRouter('/filter', module: FilterModule()),
        ModularRouter('/info', module: InfoModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
