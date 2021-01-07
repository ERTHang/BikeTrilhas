import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_page.dart';

class DisplayModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => DisplayController(i.get())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => DisplayPage()),
      ];

  static Inject get to => Inject<DisplayModule>.of();
}
