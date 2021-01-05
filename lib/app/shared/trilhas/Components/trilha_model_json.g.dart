// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trilha_model_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrilhaModelJson _$TrilhaModelJsonFromJson(Map<String, dynamic> json) {
  return TrilhaModelJson(
    json['codt'] as int,
    json['nome'] as String,
  )
    ..polylineCoordinates = (json['polylineCoordinates'] as List)
        ?.map((e) => (e as List)
            ?.map((e) => e == null
                ? null
                : LatLngJson.fromJson(e as Map<String, dynamic>))
            ?.toList())
        ?.toList()
    ..waypoints = (json['waypoints'] as List)
        ?.map((e) =>
            e == null ? null : WaypointJson.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TrilhaModelJsonToJson(TrilhaModelJson instance) =>
    <String, dynamic>{
      'codt': instance.codt,
      'nome': instance.nome,
      'polylineCoordinates': instance.polylineCoordinates
          ?.map((e) => e?.map((e) => e?.toJson())?.toList())
          ?.toList(),
      'waypoints': instance.waypoints?.map((e) => e?.toJson())?.toList(),
    };
