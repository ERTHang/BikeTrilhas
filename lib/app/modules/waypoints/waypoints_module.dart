import 'package:biketrilhas_modular/app/modules/waypoints/waypoints_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/waypoints/waypoints_page.dart';

class WaypointsModule extends Module {
  @override
  final List<Bind> binds = [
        Bind.singleton((i) => WaypointsController(i.get())),
      ];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => WaypointsPage()),
      ];
}
