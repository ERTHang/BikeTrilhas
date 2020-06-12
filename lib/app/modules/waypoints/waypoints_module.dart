import 'package:biketrilhas_modular/app/modules/waypoints/waypoints_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/waypoints/waypoints_page.dart';

class WaypointsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => WaypointsController(i.get())),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => WaypointsPage()),
      ];

  static Inject get to => Inject<WaypointsModule>.of();
}
