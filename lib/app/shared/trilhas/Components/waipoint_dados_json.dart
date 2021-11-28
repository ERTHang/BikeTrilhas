
import 'package:json_annotation/json_annotation.dart';
part "waipoint_dados_json.g.dart";

@JsonSerializable(explicitToJson: true)
class DadosWaypointJson{
  int codwp;
  int codt;
  String nome;
  String descricao;
  int numImagens;
  List<String> categorias = [];
  List<String> imagens = [];

  DadosWaypointJson(this.codwp, this.codt, this.nome, this.descricao, this.numImagens, this.categorias, this.imagens);

  factory DadosWaypointJson.fromJson(Map<String, dynamic> json) => _$DadosWaypointJsonFromJson(json);

  Map<String, dynamic> toJson() => _$DadosWaypointJsonToJson(this);
}