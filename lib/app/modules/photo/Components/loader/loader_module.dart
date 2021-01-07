import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_page.dart';

class LoaderModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LoaderController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => LoaderPage()),
      ];

  static Inject get to => Inject<LoaderModule>.of();
}
