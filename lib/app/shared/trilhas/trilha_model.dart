import 'package:biketrilhas_modular/app/shared/trilhas/Components/latlngjson.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/Components/trilha_model_json.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/Components/waypoint_json.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrilhaModel {
  int codt;
  String nome;
  List<List<LatLng>> polylineCoordinates = [];
  List<WaypointModel> waypoints = [];
  //Teste
  TrilhaModel(this.codt, this.nome);
//s
  TrilhaModelJson toJson() {
    TrilhaModelJson trilha = TrilhaModelJson(codt, nome);
    for (var coordList in this.polylineCoordinates) {
      trilha.polylineCoordinates.add([]);
      for (var coord in coordList) {
        trilha.polylineCoordinates.last
            .add(LatLngJson(coord.latitude, coord.longitude));
      }
    }
    for (var waypoint in this.waypoints) {
      trilha.waypoints.add(WaypointJson(waypoint.codigo,
          LatLngJson(waypoint.posicao.latitude, waypoint.posicao.longitude)));
    }
    return trilha;
  }

  fromJson(TrilhaModelJson json) {
    this.codt = json.codt;
    this.nome = json.nome;
    for (var waypoint in json.waypoints) {
      this.waypoints.add(WaypointModel(
          codigo: waypoint.codigo,
          posicao: LatLng(waypoint.posicao.lat, waypoint.posicao.lng)));
    }
    for (var coordList in json.polylineCoordinates) {
      this.polylineCoordinates.add([]);
      for (var coord in coordList) {
        this.polylineCoordinates.last.add(LatLng(coord.lat, coord.lng));
      }
    }
  }

  //To String
  @override
  String toString() {
    return '\nCod: ${this.codt}\nNome: ${this.nome}';
  }
}
