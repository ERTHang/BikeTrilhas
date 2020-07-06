import 'dart:typed_data';

import 'package:biketrilhas_modular/app/shared/filter/filter_repository.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'dart:ui' as ui;

import 'package:photo_view/photo_view.dart';

part 'map_controller.g.dart';

class MapController = _MapControllerBase with _$MapController;

abstract class _MapControllerBase with Store {
  final FilterRepository filterRepository;
  final TrilhaRepository trilhaRepository;
  final InfoRepository infoRepository;
  DadosTrilhaModel modelTrilha;
  DadosWaypointModel modelWaypoint;
  @observable
  ObservableFuture<List<TrilhaModel>> trilhas;
  @observable
  ObservableFuture<CameraPosition> position;
  Set<Marker> markers = {};
  Set<Marker> routeMarkers = {};
  Set<Polyline> polylines = {};
  BitmapDescriptor markerIcon;
  BitmapDescriptor markerIconTapped;
  List<int> trilhasFiltradas = [];
  List<int> temp = [];
  List<int> typeFilter = [];
  bool filterClear;
  int typeNum;
  final scaffoldState = GlobalKey<ScaffoldState>();
  int tappedTrilha;
  int tappedWaypoint;
  List<TrilhaModel> createdTrails = [];
  LatLng routeOrig;
  LatLng routeDest;
  Function state;
  PersistentBottomSheetController sheet;
  PersistentBottomSheetController nameSheet;

  @action
  _MapControllerBase(
      this.trilhaRepository, this.filterRepository, this.infoRepository) {
    trilhas = trilhaRepository.getAllTrilhas().asObservable();
    position = getUserPos().asObservable();
  }

  @action
  init() async {
    filterClear = false;
    typeNum = 2;
    typeFilter = await filterRepository.getFiltered([2], [], [], [], [], []);
    trilhasFiltradas = typeFilter;
    final Uint8List iconBytes = await getBytesFromAsset('images/bola.png', 20);
    markerIcon = BitmapDescriptor.fromBytes(iconBytes);
    final Uint8List iconBytes2 =
        await getBytesFromAsset('images/bola3.png', 20);
    markerIconTapped = BitmapDescriptor.fromBytes(iconBytes2);
  }

  @action
  Future<CameraPosition> getUserPos() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    Position pos = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return CameraPosition(
        target: LatLng(pos.latitude, pos.longitude), zoom: 15);
  }

  getRoute() async {
    var newTrail = await trilhaRepository.getRoute(routeOrig, routeDest);
    createdTrails.add(newTrail);
    bottomSheetTempTrail(newTrail);
    tappedWaypoint = null;
    tappedTrilha = newTrail.codt;
    getPolylines();
    state();
  }

  @action
  getPolylines() {
    polylines.clear();
    markers.clear();
    for (var trilha in createdTrails) {
      Polyline pol = Polyline(
        zIndex: (tappedTrilha == trilha.codt) ? 2 : 1,
        consumeTapEvents: (trilhasFiltradas != [0]),
        polylineId: PolylineId(trilha.codt.toString()),
        color: (trilha.codt == tappedTrilha) ? Colors.red : Colors.blue,
        onTap: () {
          tappedWaypoint = null;
          tappedTrilha = trilha.codt;
          state();
          bottomSheetTempTrail(trilha);
        },
        points: trilha.polylineCoordinates,
        width: 3,
        visible: (trilhasFiltradas != [0]),
      );
      polylines.add(pol);
      markers.addAll([
        Marker(
          markerId: MarkerId(trilha.waypoints[0].codigo.toString()),
          visible: trilhasFiltradas != [0],
          position: trilha.waypoints[0].posicao,
        ),
        Marker(
          markerId: MarkerId(trilha.waypoints[1].codigo.toString()),
          visible: trilhasFiltradas != [0],
          position: trilha.waypoints[1].posicao,
        )
      ]);
    }
    for (var trilha in trilhas.value) {
      Polyline pol = Polyline(
        zIndex: (tappedTrilha == trilha.codt) ? 2 : 1,
        consumeTapEvents: (trilhasFiltradas.isEmpty)
            ? true
            : (trilhasFiltradas.contains(trilha.codt) ||
                tappedTrilha == trilha.codt),
        polylineId: PolylineId(trilha.codt.toString()),
        color: (trilha.codt == tappedTrilha) ? Colors.red : Colors.blue,
        onTap: () {
          tappedWaypoint = null;
          tappedTrilha = trilha.codt;
          state();
          bottomSheetTrilha(trilha.codt);
        },
        points: trilha.polylineCoordinates,
        width: 3,
        visible: (trilhasFiltradas.isEmpty)
            ? true
            : (trilhasFiltradas.contains(trilha.codt) ||
                tappedTrilha == trilha.codt),
      );
      polylines.add(pol);
      for (var waypoint in trilha.waypoints) {
        Marker mar = Marker(
          zIndex: (tappedWaypoint == waypoint.codigo) ? 2 : 1,
          consumeTapEvents: (trilhasFiltradas.isEmpty)
              ? true
              : (trilhasFiltradas.contains(trilha.codt) ||
                  tappedTrilha == trilha.codt),
          markerId: MarkerId(waypoint.codigo.toString()),
          position: waypoint.posicao,
          onTap: () {
            tappedTrilha = null;
            bottomSheetWaypoint(waypoint.codigo);
            tappedWaypoint = waypoint.codigo;
            state();
          },
          icon: (waypoint.codigo == tappedWaypoint)
              ? markerIconTapped
              : markerIcon,
          anchor: Offset(0.5, 0.5),
          visible: (trilhasFiltradas.isEmpty)
              ? true
              : (trilhasFiltradas.contains(trilha.codt) ||
                  tappedTrilha == trilha.codt),
        );
        markers.add(mar);
      }
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  filtrar(List<int> filtros, bool typeOnly, bool type, int typeValue) {
    if (type) {
      typeChange(typeValue);
    }
    filterClear = !typeOnly;
    print(typeOnly);
    print(filterClear);
    trilhasFiltradas = filtros;
  }

  typeChange(int typeValue) async {
    typeFilter =
        await filterRepository.getFiltered([typeValue], [], [], [], [], []);
    typeNum = typeValue;
  }

  bottomSheetTempTrail(TrilhaModel trilha) async {
    modelTrilha = null;
    modelWaypoint = null;
    sheet = scaffoldState.currentState.showBottomSheet(
      (context) {
        return Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 80,
              padding: EdgeInsets.fromLTRB(0, 28, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                createdTrails.remove(trilha);
                getPolylines();
                sheet = null;
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
                  sheet = null;
                  Navigator.pop(context);
                  nameSheet =
                      scaffoldState.currentState.showBottomSheet((context) {
                    return Container(
                      width: MediaQuery.of(scaffoldState.currentContext)
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
                          nameSheet = null;
                          bottomSheetTempTrail(trilha);
                        },
                      ),
                    );
                  });
                },
              ))
        ]);
      },
    );
  }

  bottomSheetWaypoint(int codt) async {
    modelTrilha = null;
    modelWaypoint = await infoRepository.getDadosWaypoint(codt);
    sheet = scaffoldState.currentState.showBottomSheet(
      (context) {
        return Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              width:
                  MediaQuery.of(scaffoldState.currentContext).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                            text: modelWaypoint.nome,
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ])),
                  Visibility(
                    visible: modelWaypoint.descricao.isNotEmpty,
                    child: RichText(
                        text: TextSpan(
                            text: 'Descrição: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                          TextSpan(
                              text: modelWaypoint.descricao,
                              style: TextStyle(fontWeight: FontWeight.normal))
                        ])),
                  ),
                  Visibility(
                    visible: modelWaypoint.imagens.isNotEmpty,
                    child: RichText(
                        text: TextSpan(
                      text: modelWaypoint.imagens.length == 1
                          ? 'Imagem: '
                          : 'Imagens: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                  ),
                  Visibility(
                      visible: modelWaypoint.imagens.length >= 1,
                      maintainState: false,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: modelWaypoint.imagens
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
                                            context:
                                                scaffoldState.currentContext,
                                            child: SimpleDialog(
                                              contentPadding: EdgeInsets.all(0),
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
                                                              scaffoldState
                                                                  .currentContext)
                                                          .size
                                                          .height *
                                                      0.7,
                                                  width: MediaQuery.of(
                                                              scaffoldState
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
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_downward),
                color: Colors.blue,
                onPressed: () {
                  sheet = null;
                  Navigator.pop(context);
                  nameSheet =
                      scaffoldState.currentState.showBottomSheet((context) {
                    return Container(
                      width: MediaQuery.of(scaffoldState.currentContext)
                              .size
                              .width *
                          0.8,
                      child: ListTile(
                        title: Text(modelWaypoint.nome),
                        onTap: () {
                          nameSheet = null;
                          bottomSheetWaypoint(codt);
                        },
                      ),
                    );
                  });
                },
              ))
        ]);
      },
    );
  }

  bottomSheetTrilha(int codt) async {
    modelTrilha = await infoRepository.getDadosTrilha(codt);
    sheet = scaffoldState.currentState.showBottomSheet(
      (context) {
        String bairros;
        String regioes;
        String superficies;
        if (modelTrilha.bairros.isNotEmpty) {
          bairros = modelTrilha.bairros[0];
          for (var i = 1; i < modelTrilha.bairros.length; i++) {
            bairros += ', ' + modelTrilha.bairros[i];
          }
        }

        if (modelTrilha.regioes.isNotEmpty) {
          regioes = modelTrilha.regioes[0];
          for (var i = 1; i < modelTrilha.regioes.length; i++) {
            regioes += ', ' + modelTrilha.regioes[i];
          }
        }
        if (modelTrilha.superficies.isNotEmpty) {
          superficies = modelTrilha.superficies[0];
          for (var i = 1; i < modelTrilha.superficies.length; i++) {
            superficies += ', ' + modelTrilha.superficies[i];
          }
        }
        return Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              width:
                  MediaQuery.of(scaffoldState.currentContext).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                            text: modelTrilha.nome,
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ])),
                  Visibility(
                    visible: modelTrilha.descricao.isNotEmpty,
                    child: RichText(
                        text: TextSpan(
                            text: 'Descrição: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                          TextSpan(
                              text: modelTrilha.descricao,
                              style: TextStyle(fontWeight: FontWeight.normal))
                        ])),
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'Comprimento: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: modelTrilha.comprimento.toString() + ' KM',
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ])),
                  RichText(
                      text: TextSpan(
                          text: 'Desnível: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: modelTrilha.desnivel.toString() + ' m',
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ])),
                  RichText(
                      text: TextSpan(
                          text: 'Tipo: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: modelTrilha.tipo,
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ])),
                  RichText(
                      text: TextSpan(
                          text: 'Dificuldade: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: modelTrilha.dificuldade,
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ])),
                  RichText(
                      text: TextSpan(
                          text: 'Bairros: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: bairros,
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ])),
                  RichText(
                      text: TextSpan(
                          text: 'Regiões: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
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
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                color: Colors.blue,
                icon: Icon(Icons.arrow_downward),
                onPressed: () {
                  sheet = null;
                  Navigator.pop(context);
                  nameSheet =
                      scaffoldState.currentState.showBottomSheet((context) {
                    return Container(
                      width: MediaQuery.of(scaffoldState.currentContext)
                              .size
                              .width *
                          0.8,
                      child: ListTile(
                        title: Text(modelTrilha.nome),
                        trailing: Icon(
                          Icons.arrow_upward,
                          color: Colors.blue,
                        ),
                        onTap: () {
                          nameSheet = null;
                          bottomSheetTrilha(codt);
                        },
                      ),
                    );
                  });
                },
              ))
        ]);
      },
    );
  }
}
