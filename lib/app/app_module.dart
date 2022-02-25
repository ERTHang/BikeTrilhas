import 'package:biketrilhas_modular/app/modules/filter/filter_module.dart';
import 'package:biketrilhas_modular/app/modules/info/info_module.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/modules/userroutes/userroutes_module.dart';
import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_controller.dart';
import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_module.dart';
import 'package:biketrilhas_modular/app/modules/waypoints/waypoints_module.dart';
import 'package:biketrilhas_modular/app/pages/splash/permission_page.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_module.dart';
import 'package:biketrilhas_modular/app/app_controller.dart';
import 'package:biketrilhas_modular/app/modules/login/login_module.dart';
import 'package:biketrilhas_modular/app/modules/map/map_module.dart';
import 'package:biketrilhas_modular/app/pages/splash/splash_page.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository.dart';
import 'package:biketrilhas_modular/app/shared/filter/filter_repository.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/storage/shared_prefs.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => DrawerClassController()),
    Bind.singleton((i) => AppController()),
    Bind.singleton((i) => UsertrailsController(i.get(), i.get())),
    Bind.lazySingleton((i) => MapController(i.get(), i.get(), i.get())),
    Bind.singleton((i) => InfoRepository(i.get<Dio>())),
    Bind.singleton((i) => TrilhaRepository(
        i.get<Dio>(), i.get<SharedPrefs>(), i.get<AuthController>())),
    Bind.lazySingleton((i) => AuthRepository(i.get<Dio>())),
    Bind.lazySingleton((i) => AuthController()),
    Bind.singleton((i) => FilterRepository(i.get<Dio>())),
    Bind.singleton((i) => SharedPrefs()),
    Bind.singleton((i) => Dio(BaseOptions(baseUrl: URL_BASE)))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SplashPage()),
    ModuleRoute('/login',
        module: LoginModule(), transition: TransitionType.noTransition),
    ModuleRoute('/map',
        module: MapModule(), transition: TransitionType.noTransition),
    ModuleRoute('/fotos', module: PhotoModule()),
    ModuleRoute('/userroute', module: UserroutesModule()),
    ModuleRoute('/usertrail', module: UsertrailsModule()),
    ModuleRoute('/waypoint', module: WaypointsModule()),
    ModuleRoute('/filter', module: FilterModule()),
    ModuleRoute('/info', module: InfoModule()),
    ChildRoute('/permission', child: (_, args) => PermissionPage())
  ];
}
