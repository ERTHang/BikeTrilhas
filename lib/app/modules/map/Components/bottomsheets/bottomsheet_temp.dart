import 'dart:io';

import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_controller.dart';
import 'package:biketrilhas_modular/app/shared/controller/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/utils/bottomsheet.dart';
import 'package:biketrilhas_modular/app/shared/utils/breakpoints.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_view/photo_view.dart';

bottomSheetTempTrail(
    TrilhaModel trilha, GlobalKey<ScaffoldState> keyState, Function state) {
  mapController.modelTrilha = null;
  mapController.modelWaypoint = null;
  mapController.sheet = keyState.currentState.showBottomSheet((context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isTablet = shortestSide > MOBILE_BREAKPOINT;
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Stack(children: <Widget>[
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 100,
            padding: EdgeInsets.fromLTRB(8, 10, 50, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                modifiedText(
                  'Nome: ',
                  trilha.nome,
                  isTablet,
                ),
              ],
            ),
          ),
          Visibility(
            child: Positioned(
              bottom: 44,
              right: 44,
              child: IconButton(
                icon: Icon(
                  Icons.upload_rounded,
                  color: Colors.blue,
                ),
                onPressed: () {
                  print("upload");
                  checkUpload(context, trilha);
                },
              ),
            ),
            visible: trilha.codt >= 2000000,
          ),
          Positioned(
            bottom: 44,
            right: 10,
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                alertaComEscolha(
                    context,
                    'Remover',
                    Text('Deseja remover a trilha ${trilha.nome} ?'),
                    'Voltar',
                    () {
                      Navigator.pop(context);
                      return;
                    },
                    'OK',
                    () async {
                      if (trilha.codt >= 2000000) {
                        ////AQUI ESTA O PROBLEMA DE REMOVER WAYPOINT APENAS
                        mapController.createdTrails.remove(trilha);

                        mapController.trilhaRepository
                            .deleteRecordedTrail(trilha.codt);

                        mapController.sheet.close();
                        mapController.sheet = null;
                        await state();
                        Navigator.of(context).pop();
                      } else {
                        mapController.createdRoutes.remove(trilha);

                        mapController.trilhaRepository.deleteRoute(trilha.codt);

                        mapController.sheet.close();
                        mapController.sheet = null;
                        await state();
                        Navigator.of(context).pop();
                      }
                    });
              },
            ),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                color: Colors.blue,
                icon: Icon(Icons.arrow_downward),
                onPressed: () {
                  mapController.sheet = null;
                  Navigator.pop(context);
                  mapController.nameSheet =
                      keyState.currentState.showBottomSheet((context) {
                    return ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(keyState.currentContext)
                                  .size
                                  .width *
                              0.8,
                          child: ListTile(
                            title: Text(trilha.nome),
                            trailing: Icon(
                              Icons.arrow_upward,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              mapController.nameSheet = null;
                              bottomSheetTempTrail(trilha, keyState, state);
                            },
                          ),
                        ));
                  });
                },
              ))
        ]));
  }, backgroundColor: Colors.transparent);
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

bottomSheetTempWaypoint(
    TrilhaModel trilha,
    GlobalKey<ScaffoldState> keyState,
    WaypointModel waypoint,
    DadosWaypointModel followTrailWaypoints,
    Function state) {
  mapController.modelTrilha = null;
  mapController.modelWaypoint = null;
  mapController.sheet = keyState.currentState.showBottomSheet((context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool isTablet = shortestSide > MOBILE_BREAKPOINT;
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Stack(children: <Widget>[
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 170,
            padding: EdgeInsets.fromLTRB(8, 10, 50, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                modifiedText(
                  'Nome: ',
                  followTrailWaypoints.nome,
                  isTablet,
                ),
                Visibility(
                  visible: followTrailWaypoints.descricao.isNotEmpty,
                  child: modifiedText(
                    'Descrição: ',
                    followTrailWaypoints.descricao.toString(),
                    isTablet,
                  ),
                ),
                Visibility(
                  visible: followTrailWaypoints.categorias.length > 0,
                  child: modifiedText(
                    'Categoria: ',
                    (followTrailWaypoints.categorias.join(', ')),
                    isTablet,
                  ),
                ),
                Visibility(
                  visible: followTrailWaypoints.imagens.length > 0,
                  child: RichText(
                      text: TextSpan(
                    text: followTrailWaypoints.imagens.length == 1
                        ? 'Imagem: '
                        : 'Imagens: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )),
                ),
                Visibility(
                    visible: followTrailWaypoints.imagens.length >= 1,
                    maintainState: false,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: followTrailWaypoints.imagens
                              .map((e) => GestureDetector(
                                    child: Hero(
                                      tag: e,
                                      child: Image.file(
                                        File(followTrailWaypoints.imagens[0]),
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: mapController
                                              .scaffoldState.currentContext,
                                          builder: (_) {
                                            return SimpleDialog(
                                              contentPadding: EdgeInsets.all(0),
                                              children: <Widget>[
                                                Container(
                                                  child: Stack(
                                                    children: <Widget>[
                                                      PhotoView(
                                                        imageProvider:
                                                            FileImage(File(
                                                                followTrailWaypoints
                                                                        .imagens[
                                                                    0])),
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
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {
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
            top: 5,
            right: 50,
            child: IconButton(
                icon: Icon(
                  //AQUIII
                  Icons.upload,
                  color: Colors.blue,
                ),
                onPressed: () {
                  print('Teste');
                  checkUploadWp(
                      context, waypoint, followTrailWaypoints, trilha);
                }),
          ),
          Positioned(
            top: 5,
            right: 10,
            child: IconButton(
              icon: Icon(
                //AQUIII
                Icons.delete_outline_outlined,
                color: Colors.red,
              ),
              onPressed: () {
                alertaComEscolha(
                    context,
                    'Remover',
                    Text(
                        'Deseja remover o waypoint ${followTrailWaypoints.nome}?'),
                    'VOLTAR',
                    () {
                      Navigator.pop(context);
                      for (int i = 0;
                          i < mapController.followTrailWaypoints.length;
                          i++) {
                        print("ELEMENTOS");
                        print(mapController.followTrailWaypoints
                            .elementAt(i)
                            .codwp);
                      }
                      print("ELEMENTO Q EU QRO");
                      print(followTrailWaypoints.codwp);

                      return;
                    },
                    'OK',
                    () async {
                      onClickRemoverTempWaypoint(
                          context, trilha, waypoint, state);
                      return;
                    });
              },
            ),
          ),
        ]));
  }, backgroundColor: Colors.transparent);
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

checkUploadWp(context, waypoint, followtrailwaypoint, trilha) async {
  if (!await isOnline()) {
    alert(context, "Dispositivo Offline", 'Waypoint');
  } else {
    print("checking codes trilha/wp");
    print("Realizar upload");
    print("excluir a trilha:");

    UsertrailsController usertrailsController = Modular.get();
    usertrailsController.uploadWaypoint(
        context, waypoint, followtrailwaypoint, trilha);
  }
}

checkUpload(context, trilha) async {
  if (!await isOnline()) {
    alert(context, "Dispositivo Offline", 'Trilha');
  } else {
    UsertrailsController usertrailsController = Modular.get();
    usertrailsController.uploadTrilha(context, trilha);
  }
}

onClickRemoverTempWaypoint(context, trilha, waypoint, state) async {
  for (int i = 0; i < trilha.waypoints.length; i++) {
    if (trilha.waypoints[i] == waypoint) {
      trilha.waypoints.removeAt(i);
    }
  }

  for (int i = 0; i < mapController.followTrailWaypoints.length; i++) {
    if (mapController.followTrailWaypoints.elementAt(i).codwp ==
        waypoint.codigo) {
      mapController.followTrailWaypoints.removeAt(i);
    }
  }

  mapController.trilhaRepository.deleteRecordedTrail(trilha.codt);
  await mapController.trilhaRepository.saveRecordedTrail(trilha);

  mapController.sheet.close();
  mapController.sheet = null;
  await state();
  Navigator.of(context).pop();
}
