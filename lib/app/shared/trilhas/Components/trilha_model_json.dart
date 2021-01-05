import 'package:biketrilhas_modular/app/shared/trilhas/Components/latlngjson.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/Components/waypoint_json.dart';
import 'package:json_annotation/json_annotation.dart';
part 'trilha_model_json.g.dart';

@JsonSerializable(explicitToJson: true)
class TrilhaModelJson{
  int codt;
  final String nome;
  List<List<LatLngJson>> polylineCoordinates = [];
  List<WaypointJson> waypoints = [];

  TrilhaModelJson(this.codt, this.nome);

  factory TrilhaModelJson.fromJson(Map<String, dynamic> json) => _$TrilhaModelJsonFromJson(json);
  Map<String, dynamic> toJson() => _$TrilhaModelJsonToJson(this);

  
}