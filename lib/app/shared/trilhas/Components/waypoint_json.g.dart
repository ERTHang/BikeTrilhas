// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waypoint_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaypointJson _$WaypointJsonFromJson(Map<String, dynamic> json) {
  return WaypointJson(
    json['codigo'] as int,
    json['posicao'] == null
        ? null
        : LatLngJson.fromJson(json['posicao'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WaypointJsonToJson(WaypointJson instance) =>
    <String, dynamic>{
      'codigo': instance.codigo,
      'posicao': instance.posicao?.toJson(),
    };
