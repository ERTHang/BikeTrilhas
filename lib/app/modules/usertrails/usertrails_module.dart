import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_page.dart';

class UsertrailsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => UsertrailsController(i.get(), i.get())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => UsertrailsPage()),
      ];

  static Inject get to => Inject<UsertrailsModule>.of();
}
