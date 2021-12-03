import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository_interface.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  final IAuthRepository _authRepository = Modular.get();

  @observable
  AuthStatus status = AuthStatus.loading;

  @observable
  User user;

  @action
  setUser(User value) {
    user = value;
    status = user == null ? AuthStatus.logoff : AuthStatus.login;
  }

  _AuthControllerBase() {
    _authRepository.getUser().then(setUser).catchError((e) {
      print('Erro');
    });
  }

  @action
  Future loginWithGoogle() async {
    user = await _authRepository.getGoogleLogin();
  }

  Future logout() {
    return _authRepository.getLogout();
  }

  Future loginProcedure() async {
    await _authRepository.insertUser(user);
    admin = await _authRepository.isAdmin(user.email);
    return true;
  }
}

enum AuthStatus { loading, login, logoff }
