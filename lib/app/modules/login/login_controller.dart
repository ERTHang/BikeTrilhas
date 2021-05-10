import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final InfoRepository infoRepository;

  @observable
  bool loading = false;

  _LoginControllerBase(this.infoRepository);

  @action
  Future loginWithGoogle() async {
    try {
      final auth = Modular.get<AuthController>();
      loading = true;
      await auth.loginWithGoogle();
      await infoRepository.getModels();
      Modular.to.pushReplacementNamed('/map');
    } catch (e) {
      loading = false;
    }
  }
}
