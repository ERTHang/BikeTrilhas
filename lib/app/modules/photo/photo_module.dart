import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_page.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_module.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_page.dart';

class PhotoModule extends Module {
  @override
  final List<Bind> binds = [
        Bind.singleton((i) => PhotoController(i.get())),
        Bind.singleton((i) => LoaderController()),
        Bind.singleton((i) => DisplayController(i.get())),
      ];

  final List<ModularRoute> routes = [
        ModuleRoute(Modular.initialRoute, module: LoaderModule()),
        ChildRoute('/photo', child: (_, args) => PhotoPage()),
        ChildRoute('/display', child: (_, args) => DisplayPage()),
      ];
}
