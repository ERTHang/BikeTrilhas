import 'package:biketrilhas_modular/app/modules/info/info_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/info/info_page.dart';

class InfoModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => InfoController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => InfoPage()),
      ];

  static Inject get to => Inject<InfoModule>.of();
}
