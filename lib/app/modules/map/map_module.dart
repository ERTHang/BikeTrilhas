import 'package:biketrilhas_modular/app/modules/map/Components/edicao_rotas.dart';
import 'package:biketrilhas_modular/app/modules/map/Components/edicao_waypoints.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/map/map_page.dart';

class MapModule extends Module {
  @override
  List<Bind> binds =
      [Bind.singleton((i) => MapController(i.get<TrilhaRepository>(), i.get(), i.get()))];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => MapPage()),
        ChildRoute('editor', child: (_, args) => EdicaoRotas()),
        ChildRoute('editorwaypoint', child: (_, args) => EdicaoWaypoint()),
      ];
}
