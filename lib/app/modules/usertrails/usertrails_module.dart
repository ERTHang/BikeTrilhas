import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_page.dart';

class UsertrailsModule extends Module {
  @override
  final List<Bind> binds = [
        Bind.singleton((i) => UsertrailsController(i.get(), i.get())),
      ];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => UsertrailsPage()),
      ];
}
