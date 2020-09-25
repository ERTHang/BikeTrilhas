import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrilhaModel{
  int codt;
  final String nome;
  List<List<LatLng>> polylineCoordinates = [];
  List<WaypointModel> waypoints = [];

  TrilhaModel(this.codt, this.nome);


}