import 'dart:math';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

part 'usertrails_controller.g.dart';

class UsertrailsController = _UsertrailsControllerBase
    with _$UsertrailsController;

abstract class _UsertrailsControllerBase with Store {
  _UsertrailsControllerBase(this.mapController, this.drawerClassController);

  final MapController mapController;
  final DrawerClassController drawerClassController;
  final scaffoldState = GlobalKey<ScaffoldState>();
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Function state;
  List<LatLng> routePoints = [];
  Set<Marker> routeMarkers = {};
  TrilhaModel newTrail;
  int tappedTrilha;

  getPolylines() async {
    polylines.clear();
    markers.clear();

    if (checkedTrails == null) {
      checkedTrails = 1;
      mapController.createdTrails.clear();
      mapController.createdTrails
          .addAll(await mapController.trilhaRepository.getRecordedTrails());
    }

    for (var trilha in mapController.createdTrails) {
      for (var i = 0; i < trilha.polylineCoordinates.length; i++) {
        Polyline pol = Polyline(
          zIndex: (tappedTrilha == trilha.codt) ? 2 : 1,
          consumeTapEvents: true,
          polylineId: PolylineId("rota $i " + trilha.codt.toString()),
          color: (trilha.codt == tappedTrilha) ? Colors.red : Colors.blue,
          onTap: () {
            tappedTrilha = trilha.codt;
            state();
            bottomSheetTempTrail(trilha, scaffoldState, state);
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
                bottomSheetTempTrail(trilha, scaffoldState, state);
                tappedTrilha = trilha.codt;
                state();
              },
            ),
          ),
        );
      }
    }
    state();
  }

  uploadTrilha(context, TrilhaModel trilha) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Upload"),
            content: Text(
              "Deseja realizar o upload da trilha agora?",
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Não'),
                  onPressed: () {
                    Navigator.pop(context);
                    return;
                  }),
              FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    mapController.update = false;
                    mapController.modelTrilha = DadosTrilhaModel(
                        trilha.codt,
                        trilha.nome,
                        "",
                        totalDistance(trilha.polylineCoordinates[0]),
                        0,
                        'Trilha');
                    mapController.state();
                    Navigator.pop(context);
                    Modular.to.pushNamed('/map/editor');
                  }),
            ],
          ),
        );
      },
    );
  }

  double distance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double totalDistance(List<LatLng> lista) {
    double total = 0;
    for (var i = 0; i < lista.length - 1; i++) {
      total += distance(lista[i].latitude, lista[i].longitude,
          lista[i + 1].latitude, lista[i + 1].longitude);
    }
    return num.parse(total.toStringAsFixed(2));
  }
}
