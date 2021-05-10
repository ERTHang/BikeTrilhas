import 'package:json_annotation/json_annotation.dart';
part 'latlngjson.g.dart';

@JsonSerializable(explicitToJson: true)
class LatLngJson {
  double lat;
  double lng;

  LatLngJson(this.lat, this.lng);

  factory LatLngJson.fromJson(Map<String, dynamic> json) => _$LatLngJsonFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngJsonToJson(this);
}