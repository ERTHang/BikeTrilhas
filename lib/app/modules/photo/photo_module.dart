import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_page.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_module.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_page.dart';

class PhotoModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PhotoController(i.get())),
        Bind((i) => LoaderController()),
        Bind((i) => DisplayController(i.get())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: LoaderModule()),
        ModularRouter('/photo', child: (_, args) => PhotoPage()),
        ModularRouter('/display', child: (_, args) => DisplayPage()),
      ];

  static Inject get to => Inject<PhotoModule>.of();
}
