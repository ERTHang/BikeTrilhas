// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waipoint_dados_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DadosWaypointJson _$DadosWaypointJsonFromJson(Map<String, dynamic> json) {
  return DadosWaypointJson(
    json['codwp'] as int,
    json['codt'] as int,
    json['nome'] as String,
    json['descricao'] as String,
    json['numImagens'] as int,
    (json['categorias'] as List)?.map((e) => e as String)?.toList(),
    (json['imagens'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$DadosWaypointJsonToJson(DadosWaypointJson instance) =>
    <String, dynamic>{
      'codwp': instance.codwp,
      'codt': instance.codt,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'numImagens': instance.numImagens,
      'categorias': instance.categorias,
      'imagens': instance.imagens,
    };
