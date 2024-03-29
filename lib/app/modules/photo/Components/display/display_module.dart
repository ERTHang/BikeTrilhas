import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_page.dart';

class DisplayModule extends Module {
  @override
  final List<Bind> binds = [
        Bind.singleton((i) => DisplayController(i.get())),
      ];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => DisplayPage()),
      ];
}
