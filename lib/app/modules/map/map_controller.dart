import 'dart:math';
import 'dart:typed_data';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/shared/filter/filter_repository.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:connectivity/connectivity.dart';
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
  List<TrilhaModel> createdRoutes = [];
  List<TrilhaModel> createdTrails = [];
  List<LatLng> routePoints = [];
  Function state;
  PersistentBottomSheetController sheet;
  PersistentBottomSheetController nameSheet;
  TrilhaModel newTrail;
  TrilhaModel followTrail;
  bool update = false;
  ConnectivityResult connectivityResult;

  @action
  _MapControllerBase(
      this.trilhaRepository, this.filterRepository, this.infoRepository) {
    dataReady = infoRepository.getModels().asObservable();
  }

  @action
  init() async {
    position = getUserPos().asObservable();
    filterClear = false;
    typeNum = 2;
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      trilhas = trilhaRepository
          .getAllTrilhas()
          .timeout(Duration(seconds: 10))
          .asObservable();
      typeFilter =
          await filterRepository.getFiltered([2], [], [], [], [], [], []);
      trilhasFiltradas = typeFilter;
    } else {
      trilhas = trilhaRepository.getStorageTrilhas().asObservable();
    }
    final Uint8List iconBytes = await getBytesFromAsset('images/bola.png', 20);
    markerIcon = BitmapDescriptor.fromBytes(iconBytes);
    final Uint8List iconBytes2 =
        await getBytesFromAsset('images/bola3.png', 20);
    markerIconTapped = BitmapDescriptor.fromBytes(iconBytes2);
  }

  @action
  Future<CameraPosition> getUserPos() async {
    Position pos = await _determinePosition();
    return CameraPosition(
        target: LatLng(pos.latitude, pos.longitude), zoom: 15);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviços de localização estão desabilitados');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Necessitamos da localização do usuário para o funcionamento do aplicativo');
      }

      if (permission == LocationPermission.denied) {
        return Future.error(
            'Necessitamos da localização do usuário para o funcionamento do aplicativo');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getRoute() async {
    newTrail = await trilhaRepository.getRoute(routePoints);
    routePoints.clear();
    routeMarkers.clear();
    tappedWaypoint = null;
    tappedTrilha = null;
    if (newTrail == null) {
      final snackBar = SnackBar(
          content: Text("Não conseguimos gerar uma rota com estes pontos."));
      scaffoldState.currentState.removeCurrentSnackBar();
      scaffoldState.currentState.showSnackBar(snackBar);
      state();
      return;
    }
    createdRoutes.add(newTrail);
    state();
    Modular.to.pushNamed('/userroute');
  }

  @action
  getPolylines() async {
    polylines.clear();
    markers.clear();
    if (followTrail != null) {
      for (var i = 0; i < followTrail.polylineCoordinates.length; i++) {
        Polyline pol = Polyline(
          zIndex: 3,
          consumeTapEvents: false,
          polylineId: PolylineId("rota $i " + followTrail.codt.toString()),
          color: Colors.yellow,
          points: followTrail.polylineCoordinates[i],
          width: 3,
        );
        polylines.add(pol);
      }
    }
    for (var trilha in trilhas.value) {
      for (var i = 0; i < trilha.polylineCoordinates.length; i++) {
        Polyline pol = Polyline(
          zIndex: (tappedTrilha == trilha.codt) ? 2 : 1,
          consumeTapEvents: (trilhasFiltradas.isEmpty || trilha.codt >= 2000000)
              ? true
              : (trilhasFiltradas.contains(trilha.codt) ||
                  tappedTrilha == trilha.codt),
          polylineId:
              PolylineId("trilha " + (trilha.codt + i * 10000).toString()),
          color: (trilha.codt == tappedTrilha)
              ? Colors.red
              : codigosTrilhasSalvas.contains(trilha.codt)
                  ? Colors.green
                  : Colors.blue,
          onTap: () {
            tappedWaypoint = null;
            tappedTrilha = trilha.codt;
            state();
            bottomSheetTrilha(trilha);
          },
          points: trilha.polylineCoordinates[i],
          width: 3,
          visible: isVisible(trilha),
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
          onTap: () async {
            tappedTrilha = null;
            if (await isOnline()) {
              bottomSheetWaypoint(waypoint.codigo);
            }else{
              bottomSheetWaypointOffline(waypoint.codigo);
            }
            tappedWaypoint = waypoint.codigo;
            state();
          },
          icon: (waypoint.codigo == tappedWaypoint)
              ? markerIconTapped
              : markerIcon,
          anchor: Offset(0.5, 0.5),
          visible: isVisible(trilha),
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

  bool isInRadius(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    var distanceInKM = 12742 * asin(sqrt(a));
    return distanceInKM <= 1000;
  }

  bool isVisible(TrilhaModel trilha) {
    var user = position.value.target;
    if (!isInRadius(
        user.latitude,
        user.longitude,
        trilha.polylineCoordinates[0][0].latitude,
        trilha.polylineCoordinates[0][0].longitude)) {
      return false;
    }
    return (trilhasFiltradas.isEmpty || trilha.codt >= 2000000)
        ? true
        : (trilhasFiltradas.contains(trilha.codt) ||
            tappedTrilha == trilha.codt);
  }

  Future<String> nomeTrilha(context) async {
    TextEditingController _nameController = TextEditingController();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            actions: [
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    createdTrails.add(followTrail);
                    trilhaRepository.saveRecordedTrail(followTrail);
                    Navigator.pop(context);
                    Modular.to.pushNamed('/usertrail');
                    return;
                  }),
            ],
            title: Text("Nome"),
            content: SingleChildScrollView(
              child: TextField(
                controller: _nameController,
                onChanged: (value) {
                  followTrail.nome = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
