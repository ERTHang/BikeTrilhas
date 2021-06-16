import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      await auth.loginProcedure();
      await infoRepository.getModels();
      Geolocator.getCurrentPosition().then((value) {
        Modular.to.pushReplacementNamed('/map',
            arguments: CameraPosition(
                target: LatLng(value.latitude, value.longitude), zoom: 17));
      });
    } catch (e) {
      loading = false;
    }
  }
}
