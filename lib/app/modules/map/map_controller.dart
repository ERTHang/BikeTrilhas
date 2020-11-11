import 'dart:typed_data';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/shared/filter/filter_repository.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'dart:ui' as ui;

part 'map_controller.g.dart';

class MapController = _MapControllerBase with _$MapController;

abstract class _MapControllerBase with Store {
  final FilterRepository filterRepository;
  final TrilhaRepository trilhaRepository;
  final InfoRepository infoRepository;
  DadosTrilhaModel modelTrilha;
  DadosWaypointModel modelWaypoint;
  @observable
  ObservableFuture<bool> dataReady;
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
  List<LatLng> routePoints = [];
  Function state;
  PersistentBottomSheetController sheet;
  PersistentBottomSheetController nameSheet;
  TrilhaModel newTrail;


  @action
  _MapControllerBase(
      this.trilhaRepository, this.filterRepository, this.infoRepository) {
    dataReady = infoRepository.getModels().asObservable();
    trilhas = trilhaRepository.getAllTrilhas().asObservable();
    position = getUserPos().asObservable();
  }

  @action
  init() async {
    filterClear = false;
    typeNum = 2;
    typeFilter = await filterRepository.getFiltered([2], [], [], [], [], [], []);
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
    newTrail = await trilhaRepository.getRoute(routePoints);
    routePoints.clear();
    routeMarkers.clear();
    tappedWaypoint = null;
    tappedTrilha = null;
    if (newTrail == null) {
      final snackBar = SnackBar(content: Text("Não conseguimos gerar uma rota com estes pontos."));
      scaffoldState.currentState.removeCurrentSnackBar();
      scaffoldState.currentState.showSnackBar(snackBar);
      state();
      return;
    }
    createdTrails.add(newTrail);
    state();
    Modular.to.pushNamed('/usertrail');
  }

  @action
  getPolylines() {
    polylines.clear();
    markers.clear();
    // for (var trilha in createdTrails) {
    //   for (var i = 0; i < trilha.polylineCoordinates.length; i++) {
    //     Polyline pol = Polyline(
    //       zIndex: (tappedTrilha == trilha.codt) ? 2 : 1,
    //       consumeTapEvents: (trilhasFiltradas != [0]),
    //       polylineId: PolylineId("rota $i " + trilha.codt.toString()),
    //       color: (trilha.codt == tappedTrilha) ? Colors.red : Colors.blue,
    //       onTap: () {
    //         tappedWaypoint = null;
    //         tappedTrilha = trilha.codt;
    //         state();
    //         bottomSheetTempTrail(trilha, scaffoldState, state);
    //       },
    //       points: trilha.polylineCoordinates[i],
    //       width: 3,
    //       visible: (!trilhasFiltradas.contains(0)),
    //     );
    //     polylines.add(pol);
    //     markers.addAll(
    //       List.generate(
    //         trilha.waypoints.length,
    //         (index) => Marker(
    //           markerId: MarkerId(trilha.waypoints[index].codigo.toString()),
    //           visible: (!trilhasFiltradas.contains(0)),
    //           position: trilha.waypoints[index].posicao,
    //           onTap: () {
    //             tappedWaypoint = null;
    //             bottomSheetTempTrail(trilha, scaffoldState, state);
    //             tappedTrilha = trilha.codt;
    //             state();
    //           },
    //         ),
    //       ),
    //     );
    //   }
    // }
    for (var trilha in trilhas.value) {
      for (var i = 0; i < trilha.polylineCoordinates.length; i++) {
        Polyline pol = Polyline(
          zIndex: (tappedTrilha == trilha.codt) ? 2 : 1,
          consumeTapEvents: (trilhasFiltradas.isEmpty)
              ? true
              : (trilhasFiltradas.contains(trilha.codt) ||
                  tappedTrilha == trilha.codt),
          polylineId: PolylineId("trilha " + (trilha.codt + i * 10000).toString()),
          color: (trilha.codt == tappedTrilha) ? Colors.red : Colors.blue,
          onTap: () {
            tappedWaypoint = null;
            tappedTrilha = trilha.codt;
            state();
            bottomSheetTrilha(trilha.codt);
          },
          points: trilha.polylineCoordinates[i],
          width: 3,
          visible: (trilhasFiltradas.isEmpty)
              ? true
              : (trilhasFiltradas.contains(trilha.codt) ||
                  tappedTrilha == trilha.codt),
        );
        polylines.add(pol);
      }
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
        await filterRepository.getFiltered([typeValue], [], [], [], [], [], []);
    typeNum = typeValue;
  }
}
