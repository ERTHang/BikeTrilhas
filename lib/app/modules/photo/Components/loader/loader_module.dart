import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_page.dart';

class LoaderModule extends Module {
  @override
  final List<Bind> binds = [
        Bind.singleton((i) => LoaderController()),
      ];

  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => LoaderPage()),
      ];
}
