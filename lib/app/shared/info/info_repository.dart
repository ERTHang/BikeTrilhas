import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/controller/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/models.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/constants.dart';

var connectivityResult;

class InfoRepository {
  final Dio dio;

  InfoRepository(this.dio);

  List<Bairro> bairros = [];
  List<Categoria> categorias = [];
  List<Subtipo> subtipos = [];
  List<Regiao> regioes = [];
  List<Superficie> superficies = [];
  List<Dificuldade> dificuldades = [];
  List<Cidade> cidades = [];

  Future<bool> getModels() async {
    var result;
    if (bairros.isNotEmpty ||
        categorias.isNotEmpty ||
        subtipos.isNotEmpty ||
        regioes.isNotEmpty ||
        superficies.isNotEmpty ||
        dificuldades.isNotEmpty) {
      return false;
    }
    try {
      result = await dio.get('/server/cidade');
      for (var json in (result.data as List)) {
        cidades.add(Cidade(json["cidCod"], json["cidNome"]));
      }
      result = await dio.get('/server/bairro');
      for (var json in (result.data as List)) {
        bairros.add(Bairro(json["baiCod"], json["baiNome"]));
      }
      result = await dio.get('/server/categoria');
      for (var json in (result.data as List)) {
        categorias.add(Categoria(json["catCod"], json["catNome"]));
      }
      result = await dio.get('/server/regiao');
      for (var json in (result.data as List)) {
        regioes.add(Regiao(json['regCod'], json['regNome']));
      }
      result = await dio.get('/server/subtipo');
      for (var json in (result.data as List)) {
        subtipos.add(Subtipo(json["subtip_cod"], json["subtip_nome"]));
      }
      result = await dio.get('/server/superficie');
      for (var json in (result.data as List)) {
        superficies.add(Superficie(json["supCod"], json["supNome"]));
      }
      result = await dio.get('/server/dificuldade');
      for (var json in (result.data as List)) {
        dificuldades.add(Dificuldade(json["difCod"], json["difNome"]));
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  List<String> getCidades() {
    List<String> list = [];
    for (var cid in cidades) {
      list.add(cid.cid_nome);
    }
    return list;
  }

  List<String> getCategorias() {
    List<String> list = [];
    for (var cat in categorias) {
      list.add(cat.cat_nome);
    }
    return list;
  }

  List<String> getCategoria(cods) {
    List<String> list = [];
    for (var cat in categorias) {
      if (cods.contains(cat.cat_cod)) {
        list.add(cat.cat_nome);
      }
    }
    return list;
  }

  List<String> getRegioes() {
    List<String> list = [];
    for (var reg in regioes) {
      list.add(reg.reg_nome);
    }
    return list;
  }

  List<String> getRegiao(cods) {
    List<String> list = [];
    for (var reg in regioes) {
      if (cods.contains(reg.reg_cod)) {
        list.add(reg.reg_nome);
      }
    }
    return list;
  }

  String getSubtipo(cod) {
    for (var subtipo in subtipos) {
      if (cod == subtipo.subtip_cod) {
        return subtipo.subtip_nome;
      }
    }
    return '';
  }

  List<String> getSuperficie(cods) {
    List<String> list = [];
    for (var sup in superficies) {
      if (cods.contains(sup.sup_cod)) {
        list.add(sup.sup_nome);
      }
    }
    return list;
  }

  List<String> getBairros() {
    List<String> list = [];
    for (var bai in bairros) {
      list.add(bai.bai_nome);
    }
    return list;
  }

  List<String> getBairro(cods) {
    List<String> list = [];
    for (var bai in bairros) {
      if (cods.contains(bai.bai_cod)) {
        list.add(bai.bai_nome);
      }
    }
    return list;
  }

  String getDificuldade(cod) {
    for (var dif in dificuldades) {
      if (cod == dif.dif_cod) {
        return dif.dif_nome;
      }
    }
    return '';
  }

  String getCidade(cod) {
    for (var cid in cidades) {
      if (cod == cid.cid_cod) {
        return cid.cid_nome;
      }
    }
    return '';
  }

  Future<bool> updateDadosWaypoint(int codwp, int codt, String descricao,
      String nome, List<String> categorias) async {
    List<int> catInt = [];
    final catList = getCategorias();
    for (var i = 1; i <= catList.length; i++) {
      if (categorias.contains(catList[i - 1])) {
        catInt.add(i);
      }
    }
    return (await dio.put('/server/waypoint/$codwp', data: {
      "codwp": codwp,
      "codt": codt,
      "descricao": descricao,
      "nome": nome,
      "categoriasList": catInt,
    }))
        .data;
  }

  Future<bool> updateDadosTrilha(
      int codt,
      String nome,
      String descricao,
      String tipo,
      String dif,
      List<String> superficies,
      // List<String> bairros,
      List<String> regioes,
      String subtipo) async {
    int tipCod, difCod, subtipInt;
    List<int> supInt = [];
    List<int> baiInt = [];
    List<int> regInt = [];
    tipCod = (tipo == 'Ciclovia')
        ? 2
        : (tipo == 'Trilha')
            ? 1
            : 3;

    for (var i = 1; i <= this.dificuldades.length; i++) {
      if (dif == this.dificuldades[i - 1].dif_nome) {
        difCod = i;
      }
    }

    for (var i = 1; i <= this.superficies.length; i++) {
      if (superficies.contains(this.superficies[i - 1].sup_nome)) {
        supInt.add(i);
      }
    }

    // for (var i = 1; i <= this.bairros.length; i++) {
    //   if (bairros.contains(this.bairros[i - 1].bai_nome)) {
    //     baiInt.add(i);
    //   }
    // }

    for (var i = 1; i <= this.regioes.length; i++) {
      if (regioes.contains(this.regioes[i - 1].reg_nome)) {
        regInt.add(i);
      }
    }

    for (var i = 1; i <= this.subtipos.length; i++) {
      if (subtipo == subtipos[i - 1].subtip_nome) {
        subtipInt = i;
        break;
      }
    }

    return (await dio.put('/server/dados/$codt', data: {
      "codt": codt,
      "nome": nome,
      "descricao": descricao,
      "tipo": tipCod,
      "difCod": difCod,
      "superficies": supInt,
      "bairros": baiInt,
      "regioes": regInt,
      "subtip_cod": subtipInt
    }))
        .data;
  }

  Future<List<int>> getTrilhasProximas(LatLng ponto) async {
    List<int> cods = [];
    var result =
        await dio.get('/server/feature/${ponto.longitude}/${ponto.latitude}');
    (result.data as List).forEach((element) {
      cods.add(element["cod"]);
    });
    return cods;
  }

  Future<bool> uploadWaypoint(
      WaypointModel wp, DadosWaypointModel dadoswp, int codt) async {
    //-------------------------------------------
    //-------------------------------------------
    var auth = Modular.get<AuthController>();
    FormData formData = FormData.fromMap({
      "codt": codt,
      "descricao": dadoswp.descricao,
      "nome": dadoswp.nome,
      "geometria": "${wp.posicao.longitude} ${wp.posicao.latitude}",
      "imagens": await MultipartFile.fromFile(
        dadoswp.imagens[0],
        filename: dadoswp.imagens[0].split('/').last,
      ),
      "categorias": [],
      "email": auth.user.email,
    });
    var response = (await dio.post('/server/waypoint', data: formData));
    updateDadosWaypoint(response.data, codt, dadoswp.descricao, dadoswp.nome,
        dadoswp.categorias);
    mapController.followTrailWaypoints.removeWhere(
        (element) => element.codwp == mapController.newWaypoint.codigo);
    mapController.createdTrails
        .removeWhere((element) => element.codt == mapController.trailAux.codt);
    TrilhaRepository trilhaRepository = Modular.get();
    trilhaRepository.deleteRecordedWaypoint(mapController.newWaypoint.codigo);
    trilhaRepository.deleteRecordedTrail(mapController.trailAux.codt);

    return response.data != -1;
  }

  Future<int> uploadTrilha(
      List<List<LatLng>> geometria,
      String nome,
      String descricao,
      String tipo,
      String dif,
      List<String> superficies,
      // List<String> bairros,
      List<String> regioes,
      String subtipo,
      double comprimento,
      double desnivel,
      int cidade,
      List<WaypointModel> waypoints,
      List<DadosWaypointModel> dadoswp,
      int oldcodt) async {
    var auth = Modular.get<AuthController>();
    int cidCod, tipCod, difCod, subtipInt;
    List<int> supInt = [];
    List<int> baiInt = [];
    List<int> regInt = [];
    List<String> geoList = [];
    tipCod = (tipo == 'Ciclovia')
        ? 2
        : (tipo == 'Trilha')
            ? 1
            : 3;

    for (var i = 1; i <= this.dificuldades.length; i++) {
      if (dif == this.dificuldades[i - 1].dif_nome) {
        difCod = i;
      }
    }

    if (difCod == null) {
      difCod = 1;
    }

    for (var i = 1; i <= this.superficies.length; i++) {
      if (superficies.contains(this.superficies[i - 1].sup_nome)) {
        supInt.add(i);
      }
    }

    // for (var i = 1; i <= this.bairros.length; i++) {
    //   if (bairros.contains(this.bairros[i - 1].bai_nome)) {
    //     baiInt.add(i);
    //   }
    // }

    for (var i = 1; i <= this.regioes.length; i++) {
      if (regioes.contains(this.regioes[i - 1].reg_nome)) {
        regInt.add(i);
      }
    }

    for (var i = 1; i <= this.subtipos.length; i++) {
      if (subtipo == subtipos[i - 1].subtip_nome) {
        subtipInt = i;
        break;
      }
    }
    if (subtipInt == null) subtipInt = 1;

    for (var geoponto in geometria) {
      var geoString = "";
      for (var ponto in geoponto) {
        if (geoString != "") {
          geoString += ", ";
        }
        geoString += "${ponto.longitude} ${ponto.latitude}";
      }
      geoList.add(geoString);
    }

    var result = (await dio.post('/server/trilhatemp', data: {
      "comprimento": comprimento,
      "desnivel": desnivel,
      "nome": nome,
      "descricao": descricao,
      "tip_cod": tipCod,
      "dif_cod": difCod,
      "cid_cod": cidCod,
      "superficies": supInt,
      "bairros": baiInt,
      "regioes": regInt,
      "subtip_cod": subtipInt,
      "geometria": geoList,
      "quali_cod": 3,
      "email": auth.user.email
    }));

    if (result.data != -1) {
      int n = 0;
      waypoints.forEach((element) async {
        uploadWaypoint(element, dadoswp[n], result.data);
        n++;
      });
      mapController.createdTrails
          .removeWhere((element) => element.codt == oldcodt);
      TrilhaRepository trilhaRepository = Modular.get();
      trilhaRepository.deleteRecordedTrail(oldcodt);
    }

    return result.data;
  }

  Future<DadosTrilhaModel> getDadosTrilha(int codt) async {
    if (await isOnline()) {
      var result = (await dio.get('/server/naogeografico',
              queryParameters: {"tipo": "trilha", "cod": codt}))
          .data[0];
      DadosTrilhaModel model = DadosTrilhaModel(
          codt,
          result['nome'],
          result['descricao'],
          (((result['comprimento'] as double) * 100).floor()) / 100,
          (((result['desnivel'] as double) * 100).floor()) / 100,
          (result['tip_cod'] == 1)
              ? 'Trilha'
              : (result['tip_cod'] == 2)
                  ? 'Ciclovia'
                  : 'Cicloturismo');
      model.regioes = getRegiao(result['regioes']);
      model.superficies = getSuperficie(result['superficies']);
      model.bairros = getBairro(result['bairros']);
      model.dificuldade = getDificuldade(result['dif_cod']);
      model.subtipo = getSubtipo(result['subtip_cod']);

      return model;
    } else {
      await getPref();
      if (codigosTrilhasSalvas.contains(codt)) {
        var result = await sharedPrefs.read(codt.toString());
        DadosTrilhaModel model = DadosTrilhaModel(
          codt,
          result['nome'],
          '',
          result['comprimento'],
          result['desnivel'],
          result['tipo'],
        );

        List<String> bairros = [];
        for (var b in result['bairros']) {
          bairros.add(b);
        }

        List<String> regioes = [];
        for (var r in result['regioes']) {
          regioes.add(r);
        }

        List<String> superficies = [];
        for (var s in result['superficies']) {
          superficies.add(s);
        }

        model.regioes = regioes;
        model.superficies = superficies;
        model.bairros = bairros;
        model.dificuldade = result['dificuldade'];
        model.subtipo = '';

        return model;
      }
      return null;
    }
  }

  Future<DadosWaypointModel> getDadosWaypoint(int codwp) async {
    if (await isOnline()) {
      var result = (await dio.get('/server/naogeografico',
              queryParameters: {"tipo": "waypoint", "cod": codwp}))
          .data[0];
      DadosWaypointModel model = DadosWaypointModel(
          codwp: codwp,
          codt: result['cod'],
          nome: result['nome'],
          descricao: result['descricao'],
          numImagens: result['numeroDeImagens']);
      for (var i = 1; i <= model.numImagens; i++) {
        model.imagens.add(URL_BASE + 'server/byteimage/$i/$codwp');
      }
      model.categorias = getCategoria(result['categoriaWaypoint']);

      return model;
    } else {
      var json = await sharedPrefs.read(codwp.toString());
      DadosWaypointModel aux = dadosWaypointModelfromJson(json);
      return aux;
    }
  }
}

dadosWaypointModelfromJson(json) {
  int numImagens = json['numImagens'];
  DadosWaypointModel model = DadosWaypointModel(
      codwp: json['codwp'],
      codt: json['codt'],
      nome: json['nome'],
      descricao: json['descricao'],
      numImagens: numImagens);
  if (numImagens >= 1) {
    model.imagens = [json['imagens'][0].toString()];
  }
  return model;
}
