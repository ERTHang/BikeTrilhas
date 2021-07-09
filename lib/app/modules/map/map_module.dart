import 'package:biketrilhas_modular/app/modules/map/Components/edicao_trilhas.dart';
import 'package:biketrilhas_modular/app/modules/map/Components/edicao_waypoints.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/map/map_page.dart';

class MapModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton(
        (i) => MapController(i.get<TrilhaRepository>(), i.get(), i.get()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => MapPage(
              position: args.data,
            )),
    ChildRoute('editor', child: (_, args) => EdicaoTrilhas()),
    ChildRoute('editorwaypoint',
        child: (_, args) => EdicaoWaypoint(
              editMode: args.data,
            )),
  ];
}
