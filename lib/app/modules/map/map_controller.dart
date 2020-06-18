import 'dart:typed_data';

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
  final TrilhaRepository trilhaRepository;
  @observable
  ObservableFuture<List<TrilhaModel>> trilhas;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  @observable
  ObservableFuture<CameraPosition> position;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  BitmapDescriptor markerIcon;
  List<int> trilhasFiltradas = [];

  @action
  _MapControllerBase(this.trilhaRepository) {
    trilhas = trilhaRepository.getAllTrilhas().asObservable();
  }

  @action
  init() async {
    position = getUserPos().asObservable();
    final Uint8List iconBytes = await getBytesFromAsset('images/bola.png', 20);
    markerIcon = BitmapDescriptor.fromBytes(iconBytes);
  }

  @action
  Future<CameraPosition> getUserPos() async {
    Position pos = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return CameraPosition(
        target: LatLng(pos.latitude, pos.longitude), zoom: 15);
  }

  @action
  getPolylines() {
    polylines.clear();
    markers.clear();
    for (var trilha in trilhas.value) {
      Polyline pol = Polyline(
        polylineId: PolylineId(trilha.nome),
        color: Colors.blue,
        points: trilha.polylineCoordinates,
        width: 2,
        visible: (trilhasFiltradas.isEmpty)
            ? true
            : trilhasFiltradas.contains(trilha.codt),
      );
      polylines.add(pol);
      for (var waypoint in trilha.waypoints) {
        Marker mar = Marker(
          markerId: MarkerId(waypoint.codigo.toString()),
          position: waypoint.posicao,
          onTap: () {
            
          },
          icon: markerIcon,
          anchor: Offset(0.5, 0.5),
          visible: (trilhasFiltradas.isEmpty)
            ? true
            : trilhasFiltradas.contains(trilha.codt),
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

  filtrar(List<int> filtros) {
    trilhasFiltradas = filtros;
  }
}
