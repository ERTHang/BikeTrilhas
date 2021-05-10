import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:mobx/mobx.dart';

part 'waypoints_controller.g.dart';

class WaypointsController = _WaypointsControllerBase with _$WaypointsController;

abstract class _WaypointsControllerBase with Store {
  _WaypointsControllerBase(this.mapController);
  final MapController mapController;

}
