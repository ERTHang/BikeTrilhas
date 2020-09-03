import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {

  @observable
  bool loading = false;

  @action
  Future loginWithGoogle() async {
    try {
      final auth = Modular.get<AuthController>();
      loading = true;
      await auth.loginWithGoogle();
      Modular.to.pushReplacementNamed('/map');
    } catch (e) {
      loading = false;
    }
  }
}
