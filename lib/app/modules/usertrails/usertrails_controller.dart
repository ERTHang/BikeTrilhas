import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

part 'usertrails_controller.g.dart';

class UsertrailsController = _UsertrailsControllerBase
    with _$UsertrailsController;

abstract class _UsertrailsControllerBase with Store {
  _UsertrailsControllerBase(this.mapController){
    getPolylines();
  }
  final MapController mapController;
  final scaffoldState = GlobalKey<ScaffoldState>();
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Function state;
  int tappedTrilha;

  @action
  getPolylines() {
    mapController.polylines.clear();
    mapController.markers.clear();
    for (var trilha in mapController.createdTrails) {
      for (var i = 0; i < trilha.polylineCoordinates.length; i++) {
        Polyline pol = Polyline(
          zIndex: (tappedTrilha == trilha.codt) ? 2 : 1,
          consumeTapEvents: (mapController.trilhasFiltradas != [0]),
          polylineId: PolylineId("rota $i " + trilha.codt.toString()),
          color: (trilha.codt == tappedTrilha) ? Colors.red : Colors.blue,
          onTap: () {
            tappedTrilha = trilha.codt;
            state();
            bottomSheetTempTrail(trilha, scaffoldState);
          },
          points: trilha.polylineCoordinates[i],
          width: 3,
        );
        polylines.add(pol);
        markers.addAll(
          List.generate(
            trilha.waypoints.length,
            (index) => Marker(
              markerId: MarkerId(trilha.waypoints[index].codigo.toString()),
              position: trilha.waypoints[index].posicao,
              onTap: () {
                bottomSheetTempTrail(trilha, scaffoldState);
                tappedTrilha = trilha.codt;
                state();
              },
            ),
          ),
        );
      }
    }
  }
}
