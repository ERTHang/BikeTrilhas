import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_view/photo_view.dart';

final mapController = Modular.get<MapController>();

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

bottomSheetTrilha(TrilhaModel trilha) async {
  final AuthController auth = Modular.get();
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
                      RichText(
                          text: TextSpan(
                              text: 'Nome: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: mapController.modelTrilha.nome,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      Visibility(
                        visible: mapController.modelTrilha.descricao.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                                text: 'Descrição: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                  text: mapController.modelTrilha.descricao,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal))
                            ])),
                      ),
                      RichText(
                          text: TextSpan(
                              text: 'Comprimento: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: mapController.modelTrilha.comprimento
                                        .toString() +
                                    ' KM',
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      RichText(
                          text: TextSpan(
                              text: 'Desnível: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: mapController.modelTrilha.desnivel
                                        .toString() +
                                    ' m',
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      RichText(
                          text: TextSpan(
                              text: 'Tipo: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: mapController.modelTrilha.tipo,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      Visibility(
                        visible: mapController.modelTrilha.subtipo.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                                text: 'Subtipo: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                  text: mapController.modelTrilha.subtipo,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal))
                            ])),
                      ),
                      RichText(
                          text: TextSpan(
                              text: 'Dificuldade: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: mapController.modelTrilha.dificuldade,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      RichText(
                          text: TextSpan(
                              text: 'Bairros: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: bairros,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      RichText(
                          text: TextSpan(
                              text: 'Regiões: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: regioes,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      RichText(
                        text: TextSpan(
                          text: 'Superficies: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: superficies,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //Botão para salvar trilha
                Positioned(
                  top: 5,
                  right: 10,
                  child: IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.save_alt_outlined),
                    iconSize: 25,
                    onPressed: () async {
                      await getPrefs(context);
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
                    },
                  ),
                ),
                Positioned(
                  bottom: 110,
                  right: 10,
                  child: IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.save_alt_outlined),
                    iconSize: 25,
                    onPressed: () async {
                      trilhaRepository.saveTrilha(trilha);
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
                  visible: ADMIN.contains(auth.user.email),
                  child: Positioned(
                    bottom: 44,
                    right: 10,
                    child: IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pop(context);
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

bottomSheetWaypoint(int codt) async {
  mapController.modelTrilha = null;
  mapController.sheet =
      mapController.scaffoldState.currentState.showBottomSheet((context) {
    return FutureBuilder(
      future: getDataWaypoint(codt),
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
                      RichText(
                          text: TextSpan(
                              text: 'Nome: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: mapController.modelWaypoint.nome,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      Visibility(
                        visible:
                            mapController.modelWaypoint.descricao.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                                text: 'Descrição: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                  text: mapController.modelWaypoint.descricao,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal))
                            ])),
                      ),
                      Visibility(
                        visible: categorias.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                                text: 'Categorias: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                  text: categorias,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal))
                            ])),
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
                                    bottomSheetWaypoint(codt);
                                  },
                                ),
                              ));
                        });
                      },
                    )),
                Positioned(
                    bottom: 44,
                    right: 10,
                    child: IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pop(context);
                        Modular.to.pushNamed('/map/editorwaypoint');
                      },
                    ))
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
                RichText(
                  text: TextSpan(
                    text: 'Nome: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: trilha.nome,
                          style: TextStyle(fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
              ],
            ),
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
                mapController.createdTrails.remove(trilha);

                mapController.trilhaRepository.deleteTrilha(trilha.codt);

                mapController.getPolylines();
                mapController.sheet = null;
                state();
                Navigator.of(context).pop();
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
