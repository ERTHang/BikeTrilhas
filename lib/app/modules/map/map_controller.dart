import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

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

  @action
  _MapControllerBase(this.trilhaRepository) {
    trilhas = trilhaRepository.getAllTrilhas().asObservable();
  }

  @action
  init() async {
    position = getUserPos().asObservable();
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
    for (var trilha in trilhas.value) {
      Polyline pol = Polyline(
        polylineId: PolylineId(trilha.nome),
        color: Colors.red,
        points: trilha.polylineCoordinates,
        width: 3,
      );
      polylines.add(pol);
    }
  }

  addPolyline(List<TrilhaModel> listTrilhas, bool clear) {
    if(clear){polylines.clear();}
    for (var trilha in listTrilhas) {
      Polyline pol = Polyline(
        polylineId: PolylineId(trilha.nome),
        color: Colors.red,
        points: trilha.polylineCoordinates,
        width: 3,
      );
      polylines.add(pol);
    }
  }
}
