import 'package:biketrilhas_modular/app/modules/info/info_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/info/info_page.dart';

class InfoModule extends Module {
  @override
  final List<Bind> binds = [
        Bind.singleton((i) => InfoController()),
      ];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => InfoPage()),
      ];
}
