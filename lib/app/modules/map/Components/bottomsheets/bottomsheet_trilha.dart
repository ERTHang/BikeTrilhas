import 'package:biketrilhas_modular/app/shared/controller/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bottomsheet_actions.dart';

bottomSheetTrilha(TrilhaModel trilha) async {
  final TrilhaRepository trilhaRepository = Modular.get();
  BottomsheetActions actions = BottomsheetActions(mapController: mapController);
  mapController.sheet =
      mapController.scaffoldState.currentState.showBottomSheet(
    (context) {
      return FutureBuilder(
        future: actions.getDataTrilha(trilha.codt),
        builder: (context, snapshot) {
          Widget wid;
          if (snapshot.hasData) {
            String bairros;
            String regioes;
            String superficies;
            if (mapController.modelTrilha.bairros.isNotEmpty) {
              bairros = mapController.modelTrilha.bairros[0];
              for (var i = 1;
                  i < mapController.modelTrilha.bairros.length;
                  i++) {
                bairros += ', ' + mapController.modelTrilha.bairros[i];
              }
            }

            if (mapController.modelTrilha.regioes.isNotEmpty) {
              regioes = mapController.modelTrilha.regioes[0];
              for (var i = 1;
                  i < mapController.modelTrilha.regioes.length;
                  i++) {
                regioes += ', ' + mapController.modelTrilha.regioes[i];
              }
            } else {
              regioes = 'Não informado';
            }
            if (mapController.modelTrilha.superficies.isNotEmpty) {
              superficies = mapController.modelTrilha.superficies[0];
              for (var i = 1;
                  i < mapController.modelTrilha.superficies.length;
                  i++) {
                superficies += ', ' + mapController.modelTrilha.superficies[i];
              }
            } else {
              superficies = 'Não informado';
            }
            getPref();

            wid = ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Stack(children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(15, 10, 50, 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // ANCHOR ROW TITLE
                      Row(children: [
                        Expanded(
                          child: Center(
                              child: title(mapController.modelTrilha.nome)),
                        )
                      ]),
                      // ANCHOR ROW Description
                      Row(children: [
                        Expanded(
                            child: Center(
                          child: Container(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Visibility(
                              visible: mapController
                                  .modelTrilha.descricao.isNotEmpty,
                              child: description(
                                  mapController.modelTrilha.descricao),
                            ),
                          ),
                        )),
                      ]),
                      // ANCHOR ROW 1
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: modifiedText(
                                  'Comprimento: ',
                                  mapController.modelTrilha.comprimento
                                          .toString() +
                                      ' KM')),
                          Expanded(
                              child: modifiedText('Dificuldade: ',
                                  mapController.modelTrilha.dificuldade)),
                        ]),
                      ),

                      // ANCHOR ROW 2
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: modifiedText(
                                    'Tipo: ', mapController.modelTrilha.tipo),
                              ),
                              Expanded(
                                  child: Visibility(
                                visible: mapController
                                    .modelTrilha.subtipo.isNotEmpty,
                                child: modifiedText('Subtipo: ',
                                    mapController.modelTrilha.subtipo),
                              )),
                            ]),
                      ),
                      // ANCHOR ROW 3
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                  child: modifiedText('Regioes: ', regioes)),
                              Expanded(
                                  child: modifiedText(
                                      'Superficies: ', superficies)),
                            ]),
                      ),
                      // ANCHOR ROW 4
                      Container(
                          child: Row(
                        children: [
                          modifiedText(
                              'Desnivel: ',
                              mapController.modelTrilha.desnivel.toString() +
                                  ' m'),
                        ],
                      ))
                    ],
                  ),
                ),

                // Botão para remover do servidor
                actions.removerServer(context, trilha, trilhaRepository),
                //Botão para remover trilha
                actions.removerTrilha(context, trilha, trilhaRepository),
                //Botão para salvar trilha
                actions.salvarTrilha(context, trilha, trilhaRepository),

                actions.upAndDown(context, trilha, bottomSheetTrilha),

                actions.edit(context, trilha)
              ]),
            );
          } else {
            wid = ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: Container(
                color: Colors.white,
                height:
                    MediaQuery.of(mapController.scaffoldState.currentContext)
                            .size
                            .height *
                        0.2,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          return wid;
        },
      );
    },
    backgroundColor: Colors.transparent,
  );
  final auxSheet = mapController.sheet;
  final auxNameSheet = mapController.nameSheet;
  if (auxSheet != null) {
    auxSheet.closed.whenComplete(() {
      mapController.tappedTrilha = null;
      mapController.sheet = null;
    });
  }
  if (auxNameSheet != null) {
    auxNameSheet.closed.whenComplete(() {
      mapController.tappedTrilha = null;
      mapController.nameSheet = null;
    });
  }
}
