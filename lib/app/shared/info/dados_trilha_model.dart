class DadosTrilhaModel {
  final int codt;
  final String nome;
  final String descricao;
  final double comprimento;
  final double desnivel;
  final String tipo;
  String dificuldade;
  List<String> bairros;
  List<String> regioes;
  List<String> superficies;

  DadosTrilhaModel(this.codt, this.nome, this.descricao, this.comprimento, this.desnivel, this.tipo);
}