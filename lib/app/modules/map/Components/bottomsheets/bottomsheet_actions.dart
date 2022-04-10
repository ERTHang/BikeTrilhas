import 'dart:io';

import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BottomsheetActions {
  final MapController mapController;

  BottomsheetActions({
    @required this.mapController,
  });

  Future<DadosTrilhaModel> getDataTrilha(int codt) async {
    mapController.modelTrilha =
        await mapController.infoRepository.getDadosTrilha(codt);
    return mapController.modelTrilha;
  }

  Future<DadosWaypointModel> getDataWaypoint(int codt) async {
    mapController.modelWaypoint =
        await mapController.infoRepository.getDadosWaypoint(codt);
    return mapController.modelWaypoint;
  }

  ///Remover trilha da memória local
  _removerTrilhaMemory(context, trilha, trilhaRepository, codt) async {
    await deleteTrilha(codt);
    await trilhaRepository.deleteTrail(codt);
    await allToDadosTrilhaModel();
    if (!await isOnline()) {
      mapController.trilhas.value.remove(trilha);
    }
    mapController.getPolylines();
    mapController.state();
    Navigator.pop(context);
    mapController.sheet.close();
    mapController.state();
  }

  Future<Map<String, dynamic>> _wayPointToJson(
      DadosWaypointModel waypoint) async {
    if (waypoint.imagens.length > 0) {
      List<String> aux = [];
      var response = await http.get(Uri.parse(waypoint.imagens[0].toString()));
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      File file =
          new File(join(documentDirectory.path, '${waypoint.nome} imagem 0'));
      file.writeAsBytesSync(response.bodyBytes);
      aux.add(file.path);

      return {
        'codwp': waypoint.codwp,
        'codt': waypoint.codt,
        'nome': waypoint.nome,
        'descricao': waypoint.descricao,
        'numImagens': waypoint.numImagens,
        'imagens': aux,
        'categorias': waypoint.categorias,
      };
    }

    return {
      'codwp': waypoint.codwp,
      'codt': waypoint.codt,
      'nome': waypoint.nome,
      'descricao': waypoint.descricao,
      'numImagens': waypoint.numImagens,
      'imagens': [],
      'categorias': waypoint.categorias,
    };
  }

  ///Salvar trilha em memória local
  _saveTrilha(
      context, TrilhaModel trilha, TrilhaRepository trilhaRepository) async {
    mostrarProgressoLinear(context, 'Salvando');
    int qntWaypoints = trilha.waypoints.length;
    if (qntWaypoints > 0) {
      List<DadosWaypointModel> dadosWaypointModel = [];
      for (int i = 0; i < qntWaypoints; i++) {
        DadosWaypointModel aux =
            await getDataWaypoint(trilha.waypoints[i].codigo);
        dadosWaypointModel.add(aux);
      }
      for (int i = 0; i < dadosWaypointModel.length; i++) {
        if (!(await sharedPrefs.haveKey('${dadosWaypointModel[i].codwp}'))) {
          var wayPointJson = await _wayPointToJson(dadosWaypointModel[i]);
          await sharedPrefs.save(
              dadosWaypointModel[i].codwp.toString(), wayPointJson);
        }
      }
    }
    trilhaRepository.saveTrilha(trilha);
    SaveTrilha(
      context,
      trilha.codt,
      trilha.nome,
      mapController.modelTrilha.comprimento,
      mapController.modelTrilha.desnivel,
      mapController.modelTrilha.tipo,
      mapController.modelTrilha.dificuldade,
      mapController.modelTrilha.bairros,
      mapController.modelTrilha.regioes,
      mapController.modelTrilha.superficies,
    );
    await allToDadosTrilhaModel();
    mapController.sheet.setState(() => {});
    Navigator.pop(context);
    Navigator.pop(context);
  }

  // Botão para remover do servidor
  Visibility removerServer(BuildContext context, TrilhaModel trilha,
      TrilhaRepository trilhaRepository) {
    return Visibility(
      child: Positioned(
        top: 5,
        right: 50,
        child: IconButton(
          color: Colors.red,
          icon: Icon(Icons.delete_outline_outlined),
          iconSize: 25,
          onPressed: () async {
            alertaComEscolha(
              context,
              'Remover',
              RichText(
                  text: TextSpan(
                      text: "Deseja remover permanentemente a trilha ",
                      style: TextStyle(color: Colors.red),
                      children: <TextSpan>[
                    TextSpan(
                        text: "${trilha.nome} ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "?", style: TextStyle(color: Colors.red)),
                  ])),
              'VOLTAR',
              () {
                Navigator.pop(context);
                return;
              },
              'OK',
              () async {
                Navigator.pop(context);
                if (await trilhaRepository.deleteTrilhaUser(trilha.codt)) {
                  mapController.trilhas.value.remove(trilha);
                  mapController.getPolylines();
                  mapController.state();
                  mapController.sheet.close();
                  alert(context, "Trilha foi excluída.", "Sucesso");
                } else {
                  alert(context, "Ocorreu um erro.", "Erro");
                }
              },
              corTitulo: Colors.red,
            );
          },
        ),
      ),
      visible: mapController.trilhasUser.contains(trilha.codt) ||
          (admin == 1 && !codigosTrilhasSalvas.contains(trilha.codt)),
    );
  }

  // Botão para remover trilha
  Visibility removerTrilha(BuildContext context, TrilhaModel trilha,
      TrilhaRepository trilhaRepository) {
    return Visibility(
      child: Positioned(
        top: 5,
        right: 10,
        child: IconButton(
          color: Colors.blue,
          icon: Icon(Icons.delete_outline_outlined),
          iconSize: 25,
          onPressed: () async {
            alertaComEscolha(
                context,
                'Remover',
                Text('Deseja remover cópia local da trilha ${trilha.nome} ?'),
                'VOLTAR',
                () {
                  Navigator.pop(context);
                  return;
                },
                'OK',
                () {
                  _removerTrilhaMemory(
                      context, trilha, trilhaRepository, trilha.codt);
                });
          },
        ),
      ),
      visible: codigosTrilhasSalvas.contains(trilha.codt),
    );
  }

  //Botão para salvar trilha
  Visibility salvarTrilha(BuildContext context, TrilhaModel trilha,
      TrilhaRepository trilhaRepository) {
    return Visibility(
      child: Positioned(
        top: 5,
        right: 10,
        child: IconButton(
          color: Colors.blue,
          icon: Icon(Icons.save_alt_outlined),
          iconSize: 25,
          onPressed: () async {
            alertaComEscolha(
                context,
                'Salvar',
                Text('Deseja salvar a trilha ${trilha.nome} ?'),
                'VOLTAR',
                () {
                  Navigator.pop(context);
                  return;
                },
                'OK',
                () {
                  _saveTrilha(context, trilha, trilhaRepository);
                });
          },
        ),
      ),
      visible: !codigosTrilhasSalvas.contains(trilha.codt),
    );
  }

  Positioned upAndDown(
      BuildContext context, TrilhaModel trilha, dynamic bottomSheet) {
    return Positioned(
        bottom: 10,
        right: 10,
        child: IconButton(
          color: Colors.blue,
          icon: Icon(Icons.arrow_downward),
          onPressed: () {
            mapController.sheet = null;
            Navigator.pop(context);
            mapController.nameSheet = mapController.scaffoldState.currentState
                .showBottomSheet((context) {
              return ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(
                                mapController.scaffoldState.currentContext)
                            .size
                            .width *
                        0.8,
                    child: ListTile(
                      title: Text(mapController.modelTrilha.nome),
                      trailing: Icon(
                        Icons.arrow_upward,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        mapController.nameSheet = null;
                        bottomSheet(trilha);
                      },
                    ),
                  ));
            }, backgroundColor: Colors.transparent);
          },
        ));
  }

  Visibility edit(BuildContext context, TrilhaModel trilha) {
    return Visibility(
      visible: admin == 1 && !codigosTrilhasSalvas.contains(trilha.codt),
      child: Positioned(
        bottom: 44,
        right: 10,
        child: IconButton(
          color: Colors.blue,
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pop(context);
            mapController.update = true;
            Modular.to.pushNamed('/map/editor');
          },
        ),
      ),
    );
  }
}
