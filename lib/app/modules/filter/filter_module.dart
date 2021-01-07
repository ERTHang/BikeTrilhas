import 'package:biketrilhas_modular/app/modules/filter/filter_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/filter/filter_page.dart';

class FilterModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => FilterController(i.get(), i.get(), i.get())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => FilterPage()),
      ];

  static Inject get to => Inject<FilterModule>.of();
}
