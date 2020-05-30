import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:mobx/mobx.dart';

part 'usertrails_controller.g.dart';

class UsertrailsController = _UsertrailsControllerBase
    with _$UsertrailsController;

abstract class _UsertrailsControllerBase with Store {
  _UsertrailsControllerBase(this.mapController);
  final MapController mapController;

}
