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

}
