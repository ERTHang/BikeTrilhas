import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';

class InfoRepository {
  final Dio dio;

  InfoRepository(this.dio);

  Future<List<String>> getCategorias() async {
    List<String> list = [];
    var result = await dio.get('/server/categoria');
    for (var json in (result.data as List)) {
      list.add(json['catNome']);
    }
    return list;
  }

  Future<List<String>> getCategoria(cods) async {
    List<String> list = [];
    var result = await dio.get('/server/categoria');
    for (var json in (result.data as List)) {
      if (cods.contains(json['catCod'])) {
        list.add(json['catNome']);
      }
    }
    return list;
  }

  Future<List<String>> getRegiao(cods) async {
    List<String> list = [];
    var result = await dio.get('/server/regiao');
    for (var json in (result.data as List)) {
      if (cods.contains(json['regCod'])) {
        list.add(json['regNome']);
      }
    }
    return list;
  }

  Future<List<String>> getSuperficie(cods) async {
    List<String> list = [];
    var result = await dio.get('/server/superficie');
    for (var json in (result.data as List)) {
      if (cods.contains(json['supCod'])) {
        list.add(json['supNome']);
      }
    }
    return list;
  }

  Future<List<String>> getBairros() async {
    List<String> list = [];
    var result = await dio.get('/server/bairro');
    for (var json in (result.data as List)) {
      list.add(json['baiNome']);
    }
    return list;
  }

  Future<List<String>> getBairro(cods) async {
    List<String> list = [];
    var result = await dio.get('/server/bairro');
    for (var json in (result.data as List)) {
      if (cods.contains(json['baiCod'])) {
        list.add(json['baiNome']);
      }
    }
    return list;
  }

  Future<String> getDificuldade(cod) async {
    String dif;
    var result = await dio.get('/server/dificuldade');
    for (var json in (result.data as List)) {
      if (cod == json['difCod']) {
        dif = json['difNome'];
      }
    }
    return dif;
  }

  Future<bool> updateDadosWaypoint(int codwp, int codt, String descricao, String nome, List<String> categorias) async {
    List<int> catInt = [];
    final catList = await getCategorias();
    for (var i = 1; i <= catList.length; i++) {
      if (categorias.contains(catList[i-1])) {
        catInt.add(i);
      }
    }
    return (await dio.put('/server/waypoint/$codwp', data: {
      "codwp": codwp,
      "codt": codt,
      "descricao": descricao,
      "nome": nome,
      "categoriasList": catInt,
    })).data;
  }

  Future<bool> updateDadosTrilha(int codt, String nome, String descricao,
      String tipo, String dif, List<String> superficies) async {
    int tipCod, difCod;
    List<int> supInt = [];
    tipCod = (tipo == 'Ciclovia') ? 2 : (tipo == 'Trilha') ? 1 : 3;
    final difList = ['Facil', 'Medio', 'Dificil', 'Muito Dificil'];
    for (var i = 1; i <= difList.length; i++) {
      if (dif == difList[i - 1]) {
        difCod = i;
      }
    }
    final supList = [
      'Asfalto',
      'Cimento',
      'Chão Batido',
      'Areia',
      'Cascalho',
      'Single Track'
    ];
    for (var i = 1; i <= supList.length; i++) {
      if (superficies.contains(supList[i-1])) {
        supInt.add(i);
      }
    }
    return (await dio.put('/server/dados/$codt', data: {
      "codt": codt,
      "nome": nome,
      "descricao": descricao,
      "tipo": tipCod,
      "difCod": difCod,
      "superficies": supInt,
    }))
        .data;
  }

  Future<DadosTrilhaModel> getDadosTrilha(int codt) async {
    var result = (await dio.get('/server/naogeografico',
            queryParameters: {"tipo": "trilha", "cod": codt}))
        .data[0];
    DadosTrilhaModel model = DadosTrilhaModel(
        codt,
        result['nome'],
        result['descricao'],
        (((result['comprimento'] as double) * 100).floor()) / 100,
        (((result['desnivel'] as double) * 100).floor()) / 100,
        (result['tip_cod'] == 1) ? 'Trilha' : (result['tip_cod'] == 2) ? 'Ciclovia' : 'Cicloturismo');
    model.regioes = await getRegiao(result['regioes']);
    model.superficies = await getSuperficie(result['superficies']);
    model.bairros = await getBairro(result['bairros']);
    model.dificuldade = await getDificuldade(result['dif_cod']);

    return model;
  }

  Future<DadosWaypointModel> getDadosWaypoint(int codwp) async {
    var result = (await dio.get('/server/naogeografico',
            queryParameters: {"tipo": "waypoint", "cod": codwp}))
        .data[0];
    DadosWaypointModel model = DadosWaypointModel(
        codwp, result['cod'] , result['nome'], result['descricao'], result['numeroDeImagens']);
    for (var i = 1; i <= model.numImagens; i++) {
      model.imagens.add(URL_BASE + '/server/byteimage/$i/$codwp');
    }
    model.categorias = await getCategoria(result['categoriaWaypoint']);

    return model;
  }
}
