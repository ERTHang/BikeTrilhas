class DadosTrilhaModel {
  int codt;
  String nome;
  String descricao;
  double comprimento;
  double desnivel;
  String tipo;
  String dificuldade;
  List<String> bairros = [];
  List<String> regioes = [];
  List<String> superficies = [];
  String subtipo;
  String quali_trilha;

  DadosTrilhaModel(this.codt, this.nome, this.descricao, this.comprimento,
      this.desnivel, this.tipo);
}
