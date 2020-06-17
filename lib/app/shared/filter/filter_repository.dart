import 'package:dio/dio.dart';

class FilterRepository {
  final Dio dio;

  FilterRepository(this.dio);

  Future<List<int>> getFiltered(List<int> tipo, List<int> dificuldade,
      List<int> regiao, List<int> bairro, List<int> superficie, List<int> categoria) async {

    tipo = check(tipo);
    dificuldade = check(dificuldade);
    bairro = check(bairro);
    regiao = check(regiao);
    superficie = check(superficie);
    categoria = check(categoria);

    List<int> result = [];


    var response = await dio.put('/server/trilha', data: {
      "tipo": tipo,
      "dificuldade": dificuldade,
      "bairro": bairro,
      "regiao": regiao,
      "superficie": superficie,
      "categoria": categoria
    });


    for (var item in (response.data as List)) {
      result.add(item['cod']);
    }

    if (result.isEmpty) {
      result = [-1];
    }

    return result;
  }

  List<int> check(List<int> value){
    if (value.isEmpty || value[0] == 0) {
      value = null;
    }
    return value;
  }
}
