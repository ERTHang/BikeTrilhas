import 'dart:math';
import 'package:biketrilhas_modular/app/modules/map/Components/bottomsheets/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/modules/map/Components/bottomsheets/bottomsheet_temp.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
part 'usertrails_controller.g.dart';

class UsertrailsController = _UsertrailsControllerBase
    with _$UsertrailsController;

abstract class _UsertrailsControllerBase with Store {
  _UsertrailsControllerBase(this.mapController, this.drawerClassController);

  TrilhaRepository trilharep = Modular.get<TrilhaRepository>();
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
  int tappedWaypoint;

  //s
  bool pressionando = false;

  getPolylines(context) async {
    polylines.clear();
    markers.clear();
    if (checkedTrails == null) {
      checkedTrails = 1;
      mapController.createdTrails.clear();
      mapController.createdTrails
          .addAll(await mapController.trilhaRepository.getRecordedTrails());
      mapController.followTrailWaypoints
          .addAll(await mapController.trilhaRepository.getRecordedWaypoint());
    }
    for (var trilha in mapController.createdTrails) {
      for (var i = 0; i < trilha.polylineCoordinates.length; i++) {
        Polyline pol = Polyline(
          zIndex: (tappedTrilha == trilha.codt) ? 2 : 1,
          consumeTapEvents: true,
          polylineId: PolylineId("rota $i " + trilha.codt.toString()),
          color: (trilha.codt == tappedTrilha) ? Colors.red : Colors.blue,
          onTap: () async {
            print('TRILHA TAPPED');
            tappedTrilha = trilha.codt;
            print(tappedTrilha);
            print(tappedTrilha);
            await state();
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
              icon: (trilha.waypoints[index].codigo == tappedWaypoint)
                  ? mapController.markerIconTapped
                  : mapController.markerIcon,
              visible: true,
              markerId: MarkerId(trilha.waypoints[index].codigo.toString()),
              position: trilha.waypoints[index].posicao,
              onTap: () {
                print(mapController.followTrailWaypoints.length);
                //teste
                markers.clear();
                state();
                mapController.state();
                DadosWaypointModel model;
                mapController.tappedWaypoint = trilha.waypoints[index].codigo;
                for (var element in mapController.followTrailWaypoints) {
                  if (element.codwp == mapController.tappedWaypoint) {
                    pressionando = true;
                    model = element;
                  }
                }
                print("-------------TAPPED WAYPOINT----------------");
                print(mapController.tappedWaypoint);
                for (var element in mapController.followTrailWaypoints) {
                  print(element.codwp);
                }
                print("-------------TAPPED WAYPOINT----------------");
                bottomSheetTempWaypoint(trilha, scaffoldState,
                    trilha.waypoints[index], model, state);
                tappedWaypoint = mapController.tappedWaypoint;
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

  uploadWaypoint(
      context, WaypointModel waypoint, DadosWaypointModel followTrailWaypoints,
      [trilha]) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Upload"),
            content: Text(
              "Deseja realizar o upload do waypoint agora?",
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
                    mapController.trailAux = trilha;
                    mapController.modelWaypoint = followTrailWaypoints;
                    mapController.newWaypoint = waypoint;

                    // Navigator.pop(context);
                    Modular.to.pushReplacementNamed('/map/editorwaypoint',
                        arguments: EditMode.ADD);
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
