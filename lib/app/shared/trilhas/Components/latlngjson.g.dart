// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latlngjson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLngJson _$LatLngJsonFromJson(Map<String, dynamic> json) {
  return LatLngJson(
    (json['lat'] as num)?.toDouble(),
    (json['lng'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LatLngJsonToJson(LatLngJson instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
