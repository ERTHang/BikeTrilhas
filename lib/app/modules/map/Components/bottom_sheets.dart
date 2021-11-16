import 'dart:io';
import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_page.dart';
import 'package:biketrilhas_modular/app/shared/auth/repositories/auth_repository_interface.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/Components/saved_routes.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_view/photo_view.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';

final mapController = Modular.get<MapController>();
final auth = Modular.get<IAuthRepository>();
var icone;

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

Widget modifiedText(titulo, valor) {
  return RichText(
      text: TextSpan(
          text: titulo,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: <TextSpan>[
        TextSpan(text: valor, style: TextStyle(fontWeight: FontWeight.normal))
      ]));
}

bottomSheetTrilha(TrilhaModel trilha) async {
  final TrilhaRepository trilhaRepository = Modular.get();
  mapController.sheet =
      mapController.scaffoldState.currentState.showBottomSheet(
    (context) {
      return FutureBuilder(
        future: getDataTrilha(trilha.codt),
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
            }
            if (mapController.modelTrilha.superficies.isNotEmpty) {
              superficies = mapController.modelTrilha.superficies[0];
              for (var i = 1;
                  i < mapController.modelTrilha.superficies.length;
                  i++) {
                superficies += ', ' + mapController.modelTrilha.superficies[i];
              }
            }
            getPref();

            wid = ClipRRect(
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
                      modifiedText('Nome: ', mapController.modelTrilha.nome),
                      Visibility(
                        visible: mapController.modelTrilha.descricao.isNotEmpty,
                        child: modifiedText(
                            'Descricao: ', mapController.modelTrilha.descricao),
                      ),
                      modifiedText(
                          'Comprimento: ',
                          mapController.modelTrilha.comprimento.toString() +
                              ' KM'),
                      modifiedText('Desnivel: ',
                          mapController.modelTrilha.desnivel.toString() + ' m'),
                      modifiedText('Tipo: ', mapController.modelTrilha.tipo),
                      Visibility(
                        visible: mapController.modelTrilha.subtipo.isNotEmpty,
                        child: modifiedText(
                            'Subtipo: ', mapController.modelTrilha.subtipo),
                      ),
                      modifiedText('Dificuldade: ',
                          mapController.modelTrilha.dificuldade),
                      modifiedText('Bairros: ', bairros),
                      modifiedText('Regioes: ', regioes),
                      modifiedText('Superficies: ', superficies),
                    ],
                  ),
                ),
                // Botão para remover do servidor
                Visibility(
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
                                  text:
                                      "Deseja remover permanentemente a trilha ",
                                  style: TextStyle(color: Colors.red),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: "${trilha.nome} ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
                            Navigator.pop(context);
                            if (await trilhaRepository
                                .deleteTrilhaUser(trilha.codt)) {
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
                      (admin == 1 &&
                          !codigosTrilhasSalvas.contains(trilha.codt)),
                ),
                //Botão para remover trilha
                Visibility(
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
                            Text(
                                'Deseja remover cópia local da trilha ${trilha.nome} ?'),
                            'VOLTAR',
                            () {
                              Navigator.pop(context);
                              return;
                            },
                            'OK',
                            () {
                              removerTrilha(context, trilha, trilhaRepository,
                                  trilha.codt);
                            });
                      },
                    ),
                  ),
                  visible: codigosTrilhasSalvas.contains(trilha.codt),
                ),
                //Botão para salvar trilha
                Visibility(
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
                              salvarTrilha(context, trilha, trilhaRepository);
                            });
                      },
                    ),
                  ),
                  visible: !codigosTrilhasSalvas.contains(trilha.codt),
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
                                  title: Text(mapController.modelTrilha.nome),
                                  trailing: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.blue,
                                  ),
                                  onTap: () {
                                    mapController.nameSheet = null;
                                    bottomSheetTrilha(trilha);
                                  },
                                ),
                              ));
                        }, backgroundColor: Colors.transparent);
                      },
                    )),
                Visibility(
                  visible:
                      admin == 1 && !codigosTrilhasSalvas.contains(trilha.codt),
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
                ),
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

bottomSheetWaypoint(int codwp, {int codt}) async {
  final TrilhaRepository trilhaRepository = Modular.get();
  mapController.modelTrilha = null;
  mapController.sheet =
      mapController.scaffoldState.currentState.showBottomSheet((context) {
    return FutureBuilder(
      future: getDataWaypoint(codwp),
      builder: (context, snapshot) {
        Widget wid;
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
          wid = ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Stack(children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 170,
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
          wid = ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: Container(
                color: Colors.white,
                height:
                    MediaQuery.of(mapController.scaffoldState.currentContext)
                            .size
                            .height *
                        0.1,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        }
        return wid;
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
  mapController.modelTrilha = null;
  mapController.sheet =
      mapController.scaffoldState.currentState.showBottomSheet((context) {
    return FutureBuilder(
      future: getDataWaypoint(codwp),
      builder: (context, snapshot) {
        Widget wid;
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
          wid = ClipRRect(
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
          wid = ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: Container(
                color: Colors.white,
                height:
                    MediaQuery.of(mapController.scaffoldState.currentContext)
                            .size
                            .height *
                        0.1,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        }
        return wid;
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

bottomSheetTempTrail(
    TrilhaModel trilha, GlobalKey<ScaffoldState> keyState, Function state) {
  mapController.modelTrilha = null;
  mapController.modelWaypoint = null;
  mapController.sheet = keyState.currentState.showBottomSheet((context) {
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
                modifiedText('Nome: ', trilha.nome),
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
                    () {
                      if (trilha.codt >= 2000000) {
                        ////AQUI ESTA O PROBLEMA DE REMOVER WAYPOINT APENAS
                        mapController.createdTrails.remove(trilha);

                        mapController.trilhaRepository
                            .deleteRecordedTrail(trilha.codt);

                        mapController.sheet.close();
                        mapController.sheet = null;
                        state();
                        Navigator.of(context).pop();
                      } else {
                        mapController.createdRoutes.remove(trilha);

                        mapController.trilhaRepository.deleteRoute(trilha.codt);

                        mapController.sheet.close();
                        mapController.sheet = null;
                        state();
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

bottomSheetTempWaypoint(TrilhaModel trilha, GlobalKey<ScaffoldState> keyState,
    WaypointModel waypoint, DadosWaypointModel followTrailWaypoints) {
  mapController.modelTrilha = null;
  mapController.modelWaypoint = null;
  mapController.sheet = keyState.currentState.showBottomSheet((context) {
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
                modifiedText('Nome: ', followTrailWaypoints.nome),
                Visibility(
                  visible: followTrailWaypoints.descricao.isNotEmpty,
                  child: modifiedText(
                      'Descrição: ', followTrailWaypoints.descricao.toString()),
                ),
                Visibility(
                  visible: followTrailWaypoints.categorias.length > 0,
                  child: modifiedText('Categoria: ',
                      (followTrailWaypoints.categorias.join(', '))),
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
            bottom: 125,
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
                        'Deseja remover o waypoint ${mapController.followTrailWaypoints[0].nome} ?'),
                    'VOLTAR',
                    () {
                      Navigator.pop(context);
                      return;
                    },
                    'OK',
                    () async {
                      /*
                      for (int i = 0; i < trilha.waypoints.length; i++) {
                        if (trilha.waypoints[i] == waypoint) {
                          trilha.waypoints.removeAt(i);
                        }
                      }
                      //mapController.followTrailWaypoints.remove(0);
                      await mapController.getPolylines();
                      await mapController.state();
                      mapController.sheet.close();*/

                      /*print('Teste');
                      print(mapController.followTrailWaypoints[0].codt);
                      print('Teste2');
                      print(mapController.createdTrails[1].waypoints);
                      print('Teste3');
                      SavedRoutes recordedTrails = SavedRoutes.fromJson(
                          await sharedPrefs.read('recordedTrails'));
                      print(recordedTrails.codes[0]);*/
                      //   Navigator.pop(context);
                      //   try {
                      //     mapController.followTrailWaypoints.remove(0);
                      //     mapController.newWaypoint = null;
                      //     mapController.getPolylines();
                      //     mapController.state();
                      //     mapController.sheet.close();
                      //   } catch (e) {
                      //     alert(context, e.toString(), 'Erro');
                      //   }
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

///Salvar trilha em memória local
salvarTrilha(
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
        var wayPointJson = await wayPointToJson(dadosWaypointModel[i]);
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

///Remover trilha da memória local
removerTrilha(context, trilha, trilhaRepository, codt) async {
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

Future<Map<String, dynamic>> wayPointToJson(DadosWaypointModel waypoint) async {
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

checkUpload(context, trilha) async {
  if (!await isOnline()) {
    alert(context, "Dispositivo Offline", 'Trilha');
  } else {
    UsertrailsController usertrailsController = Modular.get();
    usertrailsController.uploadTrilha(context, trilha);
  }
}
