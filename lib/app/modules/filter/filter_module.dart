import 'package:biketrilhas_modular/app/modules/filter/filter_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/filter/filter_page.dart';

class FilterModule extends Module {
  @override
  final List<Bind> binds = [
        Bind.singleton((i) => FilterController(i.get(), i.get(), i.get())),
      ];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => FilterPage()),
      ];
}
