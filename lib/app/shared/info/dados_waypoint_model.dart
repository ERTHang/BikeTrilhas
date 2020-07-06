class DadosWaypointModel {
  final int codwp;
  final String nome;
  final String descricao;
  final int numImagens;
  List<String> imagens = []; 

  DadosWaypointModel(this.codwp, this.nome, this.descricao, this.numImagens);
}