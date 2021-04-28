import 'package:biketrilhas_modular/app/modules/userroutes/userroutes_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/userroutes/userroutes_page.dart';

class UserroutesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => UserroutesController(i.get(), i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => UserroutesPage()),
  ];
}
