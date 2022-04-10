import 'dart:io';

import 'package:biketrilhas_modular/app/modules/map/Components/bottomsheets/bottomsheet_actions.dart';
import 'package:biketrilhas_modular/app/shared/controller/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/bottomsheet.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_view/photo_view.dart';

bottomSheetWaypoint(int codwp, {int codt}) async {
  BottomsheetActions actions = BottomsheetActions(mapController: mapController);
  final TrilhaRepository trilhaRepository = Modular.get();
  mapController.modelTrilha = null;
  mapController.sheet =
      mapController.scaffoldState.currentState.showBottomSheet((context) {
    return FutureBuilder(
      future: actions.getDataWaypoint(codwp),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String categorias = '';
          if (mapController.modelWaypoint.categorias.isNotEmpty) {
            categorias = mapController.modelWaypoint.categorias[0];
            for (var i = 1;
                i < mapController.modelWaypoint.categorias.length;
                i++) {
              categorias += ', ' + mapController.modelWaypoint.categorias[i];
            }
          }
          return ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Stack(children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 190,
                  padding: EdgeInsets.fromLTRB(8, 10, 50, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // ANCHOR ROW TITLE
                      Row(children: [
                        Expanded(
                          child: Center(
                              child: title(mapController.modelWaypoint.nome)),
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
                                  .modelWaypoint.descricao.isNotEmpty,
                              child: description(
                                  mapController.modelWaypoint.descricao),
                            ),
                          ),
                        )),
                      ]),
                      Visibility(
                        visible: categorias.isNotEmpty,
                        child: modifiedText('Categoria: ', categorias),
                      ),
                      Visibility(
                        visible: mapController.modelWaypoint.imagens.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                          text: mapController.modelWaypoint.imagens.length == 1
                              ? 'Imagem: '
                              : 'Imagens: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        )),
                      ),
                      Visibility(
                          visible:
                              mapController.modelWaypoint.imagens.length >= 1,
                          maintainState: false,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: mapController.modelWaypoint.imagens
                                    .map((e) => GestureDetector(
                                          child: Hero(
                                            tag: e,
                                            child: CachedNetworkImage(
                                              imageUrl: e,
                                              height: 80,
                                              width: 80,
                                            ),
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: mapController
                                                    .scaffoldState
                                                    .currentContext,
                                                builder: (_) {
                                                  return SimpleDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    children: <Widget>[
                                                      Container(
                                                        child: Stack(
                                                          children: <Widget>[
                                                            PhotoView(
                                                              disableGestures:
                                                                  true,
                                                              imageProvider:
                                                                  CachedNetworkImageProvider(
                                                                      e),
                                                              minScale:
                                                                  PhotoViewComputedScale
                                                                      .covered,
                                                            ),
                                                            Positioned(
                                                              top: 5,
                                                              right: 5,
                                                              child: IconButton(
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                            ),
                                                            GestureDetector(
                                                                onVerticalDragEnd:
                                                                    (details) {
                                                              double velocity =
                                                                  details
                                                                      .velocity
                                                                      .pixelsPerSecond
                                                                      .distance;
                                                              if (velocity >
                                                                  100) {
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            })
                                                          ],
                                                          fit: StackFit.expand,
                                                        ),
                                                        height: MediaQuery.of(
                                                                    mapController
                                                                        .scaffoldState
                                                                        .currentContext)
                                                                .size
                                                                .height *
                                                            0.7,
                                                        width: MediaQuery.of(
                                                                    mapController
                                                                        .scaffoldState
                                                                        .currentContext)
                                                                .size
                                                                .width *
                                                            0.7,
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        ))
                                    .toList()),
                          )),
                    ],
                  ),
                ),

                //Botão para remover do servidor

                // Visibility(
                //   child: Positioned(
                //     top: 5,
                //     right: 50,
                //     child: IconButton(
                //       color: Colors.red,
                //       icon: Icon(Icons.delete_outline_outlined),
                //       iconSize: 25,
                //       onPressed: () async {
                //         alertaComEscolha(
                //             context,
                //             'Remover',
                //             Text('Deseja remover o waypoint ${mapController.modelWaypoint.nome} ?'),
                //             'VOLTAR',
                //             () {
                //               Navigator.pop(context);
                //               return;
                //             },
                //             'OK',
                //             () async {
                //               Navigator.pop(context);
                //               if (await trilhaRepository.deleteWaypointUser(
                //                   codwp, codt)) {
                //                 mapController.trilhas.value.removeWhere(
                //                     (element) => element.codt == codt);
                //                 mapController.getPolylines();
                //                 mapController.state();
                //                 alert(
                //                     context, "Trilha foi excluída.", "Sucesso");
                //               } else {
                //                 alert(context, "Ocorreu um erro.", "Erro");
                //               }
                //             });
                //       },
                //     ),
                //   ),
                //   visible: mapController.trilhasUser.contains(codt),
                // ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_downward),
                      color: Colors.blue,
                      onPressed: () {
                        mapController.sheet = null;
                        Navigator.pop(context);
                        mapController.nameSheet = mapController
                            .scaffoldState.currentState
                            .showBottomSheet((context) {
                          return ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(mapController
                                            .scaffoldState.currentContext)
                                        .size
                                        .width *
                                    0.8,
                                child: ListTile(
                                  title: Text(mapController.modelWaypoint.nome),
                                  onTap: () {
                                    mapController.nameSheet = null;
                                    bottomSheetWaypoint(codwp);
                                  },
                                ),
                              ));
                        });
                      },
                    )),
                Visibility(
                  child: Positioned(
                      bottom: 44,
                      right: 10,
                      child: IconButton(
                        color: Colors.blue,
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          Navigator.pop(context);
                          Modular.to.pushNamed('/map/editorwaypoint',
                              arguments: EditMode.UPDATE);
                        },
                      )),
                  visible: (admin == 1 ||
                          mapController.waypointsUser.contains(codwp)) &&
                      !codigosTrilhasSalvas.contains(codt),
                ),
                Visibility(
                  child: Positioned(
                      top: 5,
                      right: 10,
                      child: IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.delete_outline_outlined),
                        onPressed: () async {
                          alertaComEscolha(
                              context,
                              'Remover',
                              RichText(
                                  text: TextSpan(
                                      text:
                                          "Deseja remover permanentemente o waypoint  ",
                                      style: TextStyle(color: Colors.red),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            "${mapController.modelWaypoint.nome} ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: "?",
                                        style: TextStyle(color: Colors.red)),
                                  ])),
                              'VOLTAR',
                              () {
                                Navigator.pop(context);
                                return;
                              },
                              'OK',
                              () async {
                                try {
                                  await trilhaRepository.deleteWaypointUser(
                                      mapController.modelWaypoint.codwp,
                                      mapController.modelWaypoint.codt);
                                  mapController.getPolylines();
                                  mapController.state();
                                  mapController.sheet.close();
                                  Navigator.pop(context);
                                } catch (e) {
                                  Navigator.pop(context);
                                  print(e.toString());
                                }
                              },
                              corTitulo: Colors.red);
                        },
                      )),
                  visible: (admin == 1 ||
                          mapController.waypointsUser.contains(codwp)) &&
                      !codigosTrilhasSalvas.contains(codt),
                ),
              ]));
        } else {
          return bottomsheetSkeleton(mapController, 0.1);
        }
      },
    );
  }, backgroundColor: Colors.transparent);
  final auxSheet = mapController.sheet;
  final auxNameSheet = mapController.nameSheet;
  if (auxSheet != null) {
    auxSheet.closed.whenComplete(() {
      mapController.tappedWaypoint = null;
      mapController.sheet = null;
    });
  }
  if (auxNameSheet != null) {
    auxNameSheet.closed.whenComplete(() {
      mapController.tappedWaypoint = null;
      mapController.nameSheet = null;
    });
  }
}

bottomSheetWaypointOffline(int codwp) async {
  BottomsheetActions actions = BottomsheetActions(mapController: mapController);
  mapController.modelTrilha = null;
  mapController.sheet =
      mapController.scaffoldState.currentState.showBottomSheet((context) {
    return FutureBuilder(
      future: actions.getDataWaypoint(codwp),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String categorias = '';
          if (mapController.modelWaypoint.categorias.isNotEmpty) {
            categorias = mapController.modelWaypoint.categorias[0];
            for (var i = 1;
                i < mapController.modelWaypoint.categorias.length;
                i++) {
              categorias += ', ' + mapController.modelWaypoint.categorias[i];
            }
          }
          return ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Stack(children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(8, 10, 50, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      modifiedText('Nome: ', mapController.modelWaypoint.nome),
                      Visibility(
                        visible:
                            mapController.modelWaypoint.descricao.isNotEmpty,
                        child: modifiedText('Descricao: ',
                            mapController.modelWaypoint.descricao),
                      ),
                      Visibility(
                        visible: categorias.isNotEmpty,
                        child: modifiedText('Categorias: ', categorias),
                      ),
                      Visibility(
                        visible: mapController.modelWaypoint.imagens.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                          text: mapController.modelWaypoint.imagens.length == 1
                              ? 'Imagem: '
                              : 'Imagens: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        )),
                      ),
                      Visibility(
                          visible:
                              mapController.modelWaypoint.imagens.length >= 1,
                          maintainState: false,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: mapController.modelWaypoint.imagens
                                    .map((e) => GestureDetector(
                                          child: Hero(
                                            tag: e,
                                            child: Image.file(
                                              File(mapController
                                                  .modelWaypoint.imagens[0]),
                                              height: 80,
                                              width: 80,
                                            ),
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: mapController
                                                    .scaffoldState
                                                    .currentContext,
                                                builder: (_) {
                                                  return SimpleDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    children: <Widget>[
                                                      Container(
                                                        child: Stack(
                                                          children: <Widget>[
                                                            PhotoView(
                                                              imageProvider: FileImage(
                                                                  File(mapController
                                                                      .modelWaypoint
                                                                      .imagens[0])),
                                                              minScale:
                                                                  PhotoViewComputedScale
                                                                      .covered,
                                                            ),
                                                            Positioned(
                                                              top: 5,
                                                              right: 5,
                                                              child: IconButton(
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                            ),
                                                          ],
                                                          fit: StackFit.expand,
                                                        ),
                                                        height: MediaQuery.of(
                                                                    mapController
                                                                        .scaffoldState
                                                                        .currentContext)
                                                                .size
                                                                .height *
                                                            0.7,
                                                        width: MediaQuery.of(
                                                                    mapController
                                                                        .scaffoldState
                                                                        .currentContext)
                                                                .size
                                                                .width *
                                                            0.7,
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        ))
                                    .toList()),
                          )),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_downward),
                      color: Colors.blue,
                      onPressed: () {
                        mapController.sheet = null;
                        Navigator.pop(context);
                        mapController.nameSheet = mapController
                            .scaffoldState.currentState
                            .showBottomSheet((context) {
                          return ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(mapController
                                            .scaffoldState.currentContext)
                                        .size
                                        .width *
                                    0.8,
                                child: ListTile(
                                  title: Text(mapController.modelWaypoint.nome),
                                  onTap: () {
                                    mapController.nameSheet = null;
                                    bottomSheetWaypoint(codwp);
                                  },
                                ),
                              ));
                        });
                      },
                    )),
                // Positioned(
                //     bottom: 44,
                //     right: 10,
                //     child: IconButton(
                //       color: Colors.blue,
                //       icon: Icon(Icons.edit),
                //       onPressed: () {
                //         Navigator.pop(context);
                //         Modular.to.pushNamed('/map/editorwaypoint',
                //             arguments: EditMode.UPDATE);
                //       },
                //     ))
              ]));
        } else {
          return bottomsheetSkeleton(mapController, 0.1);
        }
      },
    );
  }, backgroundColor: Colors.transparent);
  final auxSheet = mapController.sheet;
  final auxNameSheet = mapController.nameSheet;
  if (auxSheet != null) {
    auxSheet.closed.whenComplete(() {
      mapController.tappedWaypoint = null;
      mapController.sheet = null;
    });
  }
  if (auxNameSheet != null) {
    auxNameSheet.closed.whenComplete(() {
      mapController.tappedWaypoint = null;
      mapController.nameSheet = null;
    });
  }
}
