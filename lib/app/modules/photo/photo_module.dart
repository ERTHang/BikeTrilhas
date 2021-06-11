import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_page.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_page.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_page.dart';

class PhotoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => PhotoController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => LoaderPage()),
    ChildRoute('/photo',
        child: (_, args) => PhotoPage(
              camera: args.data,
            )),
    ChildRoute('/display',
        child: (_, args) => DisplayPage(
              path: args.data,
            )),
  ];
}
