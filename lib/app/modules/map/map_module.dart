import 'package:biketrilhas_modular/app/modules/map/Components/edicao_rotas.dart';
import 'package:biketrilhas_modular/app/modules/map/Components/edicao_waypoints.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/map/map_page.dart';

class MapModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => MapController(i.get<TrilhaRepository>(), i.get(), i.get()))
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => MapPage()),
        Router('editor', child: (_, args) => EdicaoRotas()),
        Router('editorwaypoint', child: (_, args) => EdicaoWaypoint()),
      ];

  static Inject get to => Inject<MapModule>.of();
}
