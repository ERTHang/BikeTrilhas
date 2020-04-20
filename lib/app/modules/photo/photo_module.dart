import 'package:biketrilhas_modular/app/modules/photo/photo_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/photo/photo_page.dart';

class PhotoModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PhotoController()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => PhotoPage()),
      ];

  static Inject get to => Inject<PhotoModule>.of();
}
