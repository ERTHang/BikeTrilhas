class DadosWaypointModel {
  int codwp;
  int codt;
  String nome;
  String descricao;
  int numImagens;
  List<String> categorias = [];
  List<String> imagens = [];

  DadosWaypointModel(
      {this.codwp, this.codt, this.nome, this.descricao, this.numImagens});
}
