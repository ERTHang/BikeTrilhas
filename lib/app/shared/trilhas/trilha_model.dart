import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrilhaModel{
  final int codt;
  final String nome;
  final String descricao;
  final int tipo;
  final int dificuldade;
  List<String> regiaoList = [];
  List<String> bairrosList = [];
  List<String> superficieList = [];
  List<LatLng> polylineCoordinates = [];
  List<WaypointModel> waypoints = [];

  TrilhaModel(this.codt, this.nome, this.descricao, this.tipo, this.dificuldade);


}