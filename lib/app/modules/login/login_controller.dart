import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final InfoRepository infoRepository;

  @observable
  bool loading = false;

  _LoginControllerBase(this.infoRepository);

  @action
  Future loginWithGoogle(context) async {
    try {
      final auth = Modular.get<AuthController>();
      loading = true;
      await auth.loginWithGoogle();
      await auth.loginProcedure();
      await infoRepository.getModels();
      LocationPermission _permissionGranted =
          await Geolocator.checkPermission();
      if (_permissionGranted == LocationPermission.denied) {
        locationPermissionPopUp(context);
      }
    } catch (e) {
      loading = false;
    }
  }
}
