import 'package:biketrilhas_modular/app/shared/trilhas/Components/waipoint_dados_json.dart';
import 'package:flutter/cupertino.dart';

class DadosWaypointModel {
  int codwp;
  int codt;
  String nome;
  String descricao;
  int numImagens;
  List<String> categorias = [];
  List<String> imagens = [];


  
//s
  DadosWaypointModel(
      {this.codwp, this.codt, this.nome, this.descricao, this.numImagens});

      
   DadosWaypointJson toJson() {
    DadosWaypointJson dadoswp = DadosWaypointJson(codwp, codt, nome, descricao, numImagens, categorias, imagens);
    print("DadosWp Json -------------------------- ");
    print(dadoswp);
    return dadoswp;
  }
  fromJson(DadosWaypointJson json) {
    this.codwp = json.codwp;
    this.codt = json.codt;
    this.nome = json.nome;
    this.descricao = json.descricao;
    this.numImagens = json.numImagens;
    this.categorias = json.categorias;
    this.imagens = json.imagens;
    
  }
}
