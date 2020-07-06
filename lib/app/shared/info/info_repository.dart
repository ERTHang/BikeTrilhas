import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';

class InfoRepository {
  final Dio dio;

  InfoRepository(this.dio);

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

  Future<DadosTrilhaModel> getDadosTrilha(int codt) async {
    var result = (await dio.get('/server/naogeografico',
            queryParameters: {"tipo": "trilha", "cod": codt}))
        .data[0];
    DadosTrilhaModel model = DadosTrilhaModel(
        codt,
        result['nome'],
        result['descricao'],
        (((result['comprimento'] as double)*100).floor())/100,
        (((result['desnivel'] as double)*100).floor())/100,
        (result['tipo'] == 1) ? 'Trilha' : 'Ciclovia');
    model.regioes = await getRegiao(result['regioes']);
    model.superficies = await getSuperficie(result['superficies']);
    model.bairros = await getBairro(result['bairros']);
    model.dificuldade = await getDificuldade(result['dif_cod']);

    return model;
  }

  Future<DadosWaypointModel> getDadosWaypoint(int codt) async {
    var result = (await dio.get('/server/naogeografico',
            queryParameters: {"tipo": "waypoint", "cod": codt}))
        .data[0];
    DadosWaypointModel model = DadosWaypointModel(codt, result['nome'], result['descricao'], result['numeroDeImagens']);
    for (var i = 1; i <= model.numImagens; i++) {
      model.imagens.add(URL_BASE + '/server/byteimage/$i/$codt');
    }

    return model;
  }
}
