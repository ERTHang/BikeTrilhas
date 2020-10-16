import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_view/photo_view.dart';

final controller = Modular.get<MapController>();

Future<DadosTrilhaModel> getDataTrilha(int codt) async {
  controller.modelTrilha = await controller.infoRepository.getDadosTrilha(codt);
  return controller.modelTrilha;
}

Future<DadosWaypointModel> getDataWaypoint(int codt) async {
  controller.modelWaypoint =
      await controller.infoRepository.getDadosWaypoint(codt);
  return controller.modelWaypoint;
}

bottomSheetTrilha(int codt) async {
  final AuthController auth = Modular.get();
  controller.sheet = controller.scaffoldState.currentState.showBottomSheet(
    (context) {
      return FutureBuilder(
        future: getDataTrilha(codt),
        builder: (context, snapshot) {
          Widget wid;
          if (snapshot.hasData) {
            String bairros;
            String regioes;
            String superficies;
            if (controller.modelTrilha.bairros.isNotEmpty) {
              bairros = controller.modelTrilha.bairros[0];
              for (var i = 1; i < controller.modelTrilha.bairros.length; i++) {
                bairros += ', ' + controller.modelTrilha.bairros[i];
              }
            }

            if (controller.modelTrilha.regioes.isNotEmpty) {
              regioes = controller.modelTrilha.regioes[0];
              for (var i = 1; i < controller.modelTrilha.regioes.length; i++) {
                regioes += ', ' + controller.modelTrilha.regioes[i];
              }
            }
            if (controller.modelTrilha.superficies.isNotEmpty) {
              superficies = controller.modelTrilha.superficies[0];
              for (var i = 1;
                  i < controller.modelTrilha.superficies.length;
                  i++) {
                superficies += ', ' + controller.modelTrilha.superficies[i];
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
                                text: controller.modelTrilha.nome,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      Visibility(
                        visible: controller.modelTrilha.descricao.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                                text: 'Descrição: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                  text: controller.modelTrilha.descricao,
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
                                text: controller.modelTrilha.comprimento
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
                                text:
                                    controller.modelTrilha.desnivel.toString() +
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
                                text: controller.modelTrilha.tipo,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      Visibility(
                        visible: controller.modelTrilha.subtipo.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                                text: 'Subtipo: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                  text: controller.modelTrilha.subtipo,
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
                                text: controller.modelTrilha.dificuldade,
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
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.arrow_downward),
                      onPressed: () {
                        controller.sheet = null;
                        Navigator.pop(context);
                        controller.nameSheet = controller
                            .scaffoldState.currentState
                            .showBottomSheet((context) {
                          return ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(controller
                                            .scaffoldState.currentContext)
                                        .size
                                        .width *
                                    0.8,
                                child: ListTile(
                                  title: Text(controller.modelTrilha.nome),
                                  trailing: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.blue,
                                  ),
                                  onTap: () {
                                    controller.nameSheet = null;
                                    bottomSheetTrilha(codt);
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
                height: MediaQuery.of(controller.scaffoldState.currentContext)
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
  final auxSheet = controller.sheet;
  final auxNameSheet = controller.nameSheet;
  if (auxSheet != null) {
    auxSheet.closed.whenComplete(() {
      controller.tappedTrilha = null;
      controller.sheet = null;
    });
  }
  if (auxNameSheet != null) {
    auxNameSheet.closed.whenComplete(() {
      controller.tappedTrilha = null;
      controller.nameSheet = null;
    });
  }
}

bottomSheetWaypoint(int codt) async {
  controller.modelTrilha = null;
  controller.sheet =
      controller.scaffoldState.currentState.showBottomSheet((context) {
    return FutureBuilder(
      future: getDataWaypoint(codt),
      builder: (context, snapshot) {
        Widget wid;
        if (snapshot.hasData) {
          String categorias = '';
          if (controller.modelWaypoint.categorias.isNotEmpty) {
            categorias = controller.modelWaypoint.categorias[0];
            for (var i = 1;
                i < controller.modelWaypoint.categorias.length;
                i++) {
              categorias += ', ' + controller.modelWaypoint.categorias[i];
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
                                text: controller.modelWaypoint.nome,
                                style: TextStyle(fontWeight: FontWeight.normal))
                          ])),
                      Visibility(
                        visible: controller.modelWaypoint.descricao.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                                text: 'Descrição: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                  text: controller.modelWaypoint.descricao,
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
                        visible: controller.modelWaypoint.imagens.isNotEmpty,
                        child: RichText(
                            text: TextSpan(
                          text: controller.modelWaypoint.imagens.length == 1
                              ? 'Imagem: '
                              : 'Imagens: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        )),
                      ),
                      Visibility(
                          visible: controller.modelWaypoint.imagens.length >= 1,
                          maintainState: false,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: controller.modelWaypoint.imagens
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
                                                context: controller
                                                    .scaffoldState
                                                    .currentContext,
                                                child: SimpleDialog(
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
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                }),
                                                          ),
                                                        ],
                                                        fit: StackFit.expand,
                                                      ),
                                                      height: MediaQuery.of(controller
                                                                  .scaffoldState
                                                                  .currentContext)
                                                              .size
                                                              .height *
                                                          0.7,
                                                      width: MediaQuery.of(controller
                                                                  .scaffoldState
                                                                  .currentContext)
                                                              .size
                                                              .width *
                                                          0.7,
                                                    ),
                                                  ],
                                                ));
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
                        controller.sheet = null;
                        Navigator.pop(context);
                        controller.nameSheet = controller
                            .scaffoldState.currentState
                            .showBottomSheet((context) {
                          return ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(controller
                                            .scaffoldState.currentContext)
                                        .size
                                        .width *
                                    0.8,
                                child: ListTile(
                                  title: Text(controller.modelWaypoint.nome),
                                  onTap: () {
                                    controller.nameSheet = null;
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
                height: MediaQuery.of(controller.scaffoldState.currentContext)
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
  final auxSheet = controller.sheet;
  final auxNameSheet = controller.nameSheet;
  if (auxSheet != null) {
    auxSheet.closed.whenComplete(() {
      controller.tappedWaypoint = null;
      controller.sheet = null;
    });
  }
  if (auxNameSheet != null) {
    auxNameSheet.closed.whenComplete(() {
      controller.tappedWaypoint = null;
      controller.nameSheet = null;
    });
  }
}

bottomSheetTempTrail(TrilhaModel trilha, GlobalKey<ScaffoldState> keyState, Function state) {
  controller.modelTrilha = null;
  controller.modelWaypoint = null;
  controller.sheet = keyState.currentState.showBottomSheet(
    (context) {
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
                  controller.createdTrails.remove(trilha);
                  controller.getPolylines();
                  controller.sheet = null;
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
                    controller.sheet = null;
                    Navigator.pop(context);
                    controller.nameSheet = keyState.currentState
                        .showBottomSheet((context) {
                      return ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(
                                        keyState.currentContext)
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
                                controller.nameSheet = null;
                                bottomSheetTempTrail(trilha, keyState, state);
                              },
                            ),
                          ));
                    });
                  },
                ))
          ]));
    },
    backgroundColor: Colors.transparent
  );
  final auxSheet = controller.sheet;
  final auxNameSheet = controller.nameSheet;
  if (auxSheet != null) {
    auxSheet.closed.whenComplete(() {
      controller.tappedTrilha = null;
      controller.sheet = null;
    });
  }
  if (auxNameSheet != null) {
    auxNameSheet.closed.whenComplete(() {
      controller.tappedTrilha = null;
      controller.nameSheet = null;
    });
  }
}
