
import 'package:biketrilhas_modular/app/shared/trilhas/Components/latlngjson.dart';
import 'package:json_annotation/json_annotation.dart';
part 'waypoint_json.g.dart';

@JsonSerializable(explicitToJson: true)
class WaypointJson{
  int codigo;
  LatLngJson posicao;

  WaypointJson(this.codigo, this.posicao);

  factory WaypointJson.fromJson(Map<String, dynamic> json) => _$WaypointJsonFromJson(json);
  Map<String, dynamic> toJson() => _$WaypointJsonToJson(this);
}