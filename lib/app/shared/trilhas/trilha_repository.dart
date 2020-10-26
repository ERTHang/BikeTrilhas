import 'dart:math';

import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/storage/shared_prefs.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/saved_routes.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrilhaRepository {
  final Dio dio;
  final SharedPrefs sharedPrefs;

  TrilhaRepository(this.dio, this.sharedPrefs);

  SavedRoutes savedRoutes;

  int n = 10000;

  void deleteTrilha(int codigo) {
    sharedPrefs.remove('trilha $codigo');

    savedRoutes.codes.removeWhere((element) => element == codigo);
    savedRoutes.names.removeWhere((element) => element == 'trilha $codigo');

    sharedPrefs.remove('savedRoutes');
    sharedPrefs.save('savedRoutes', savedRoutes);
  }

  Future<List<TrilhaModel>> getStorageRoutes() async {

    List<TrilhaModel> trilhas = [];

    try {
      savedRoutes = SavedRoutes.fromJson(await sharedPrefs.read('savedRoutes'));
    } catch (e) {
      print(e);
      savedRoutes = SavedRoutes([], []);
    }

    for (var i = 0; i < savedRoutes.codes.length; i++) {
      trilhas.add(TrilhaModel(n, savedRoutes.names[i]));

      print(savedRoutes.codes[i]);
      print(savedRoutes.names[i]);

      trilhas.last.polylineCoordinates.add([]);
      n++;
      // bool reversed;
      var numero = savedRoutes.codes[i];
      var point = await sharedPrefs.read('trilha $numero');

      var lat = point["latitudeTrilha"];
      var lon = point["longitudeTrilha"];
      // if ((lat as List).isNotEmpty &&
      //     sqrt(pow(lat[0] - routePoints[i].latitude, 2) +
      //             pow(lon[0] - routePoints[i].longitude, 2)) <
      //         sqrt(pow(lat[0] - routePoints[i+1].latitude, 2) +
      //             pow(lon[0] - routePoints[i+1].longitude, 2))) {
      //   trilhas.last.polylineCoordinates.last.add(routePoints[i]);
      //   reversed = false;
      // } else {
      //   trilhas.last.polylineCoordinates.last.add(routePoints[i+1]);
      //   reversed = true;
      // }
      for (var j = 0; j < (lat as List).length; j++) {
        trilhas.last.polylineCoordinates.last.add(LatLng(lat[j], lon[j]));
      }
      // rotaPolyline.last.add((reversed) ? routePoints[i] : routePoints[i+1]);
      trilhas.last.waypoints.addAll([
        WaypointModel(
          codigo: n,
          posicao: LatLng(lat[0], lon[0]),
        ),
        WaypointModel(
          codigo: 2 * n,
          posicao: LatLng((lat as List).last, (lon as List).last),
        )
      ]);
    }

      
    return trilhas;
  }

  Future<TrilhaModel> getRoute(List<LatLng> routePoints) async {
    final auth = Modular.get<AuthController>();

    List<List<LatLng>> rotaPolyline = [];
    var username = auth.user.displayName.toLowerCase();
    TrilhaModel model = TrilhaModel(n, 'Rota gerada por $username');

    for (var i = 0; i < routePoints.length - 1; i++) {
      rotaPolyline.add([]);
      // bool reversed;
      var codt = (await dio.get('/server/route', queryParameters: {
        "lat_orig": routePoints[i].latitude,
        "lon_orig": routePoints[i].longitude,
        "lat_dest": routePoints[i+1].latitude,
        "lon_dest": routePoints[i+1].longitude
      }))
          .data;

      var point = (await dio.get('/server/temp/$codt')).data;

      try {
        savedRoutes = SavedRoutes.fromJson(await sharedPrefs.read('savedRoutes'));
      } catch (Exception) {
        savedRoutes = SavedRoutes([], []);
      }

      var numero = (savedRoutes.codes.isEmpty) ? 0 : savedRoutes.codes.last + 1;
      model.codt = numero;
      sharedPrefs.save('trilha $numero', point);

      savedRoutes.names.add('Rota gerada por $username');
      savedRoutes.codes.add(numero);
      try {
        sharedPrefs.remove('savedRoutes');
      } catch (e) {
      } 
      sharedPrefs.save('savedRoutes', savedRoutes);

      var lat = point["latitudeTrilha"];
      var lon = point["longitudeTrilha"];
      // if ((lat as List).isNotEmpty &&
      //     sqrt(pow(lat[0] - routePoints[i].latitude, 2) +
      //             pow(lon[0] - routePoints[i].longitude, 2)) <
      //         sqrt(pow(lat[0] - routePoints[i+1].latitude, 2) +
      //             pow(lon[0] - routePoints[i+1].longitude, 2))) {
      //   rotaPolyline.last.add(routePoints[i]);
      //   reversed = false;
      // } else {
      //   rotaPolyline.last.add(routePoints[i+1]);
      //   reversed = true;
      // }
      for (var j = 0; j < (lat as List).length; j++) {
        rotaPolyline.last.add(LatLng(lat[j], lon[j]));
      }
      // rotaPolyline.last.add((reversed) ? routePoints[i] : routePoints[i+1]);
      model.waypoints.addAll([
        WaypointModel(
          codigo: n,
          posicao: LatLng(lat[0], lon[0]),
        ),
        WaypointModel(
          codigo: 2 * n,
          posicao: LatLng((lat as List).last, (lon as List).last),
        )
      ]);
    }
    model.polylineCoordinates = rotaPolyline;
    return model;
  }

  Future<List<TrilhaModel>> getAllTrilhas() async {
    var cods = await dio.get("/server/cods");
    var layercod = 0;
    var response = await dio.get("/server/trilhadados");
    List<TrilhaModel> list = List<TrilhaModel>();
    var layers =
        await dio.put("/server/layer", data: {"codt": (cods.data as List)});

    for (var json in (response.data as List)) {
      List<List<LatLng>> line = [];
      TrilhaModel model = TrilhaModel(
        json['codt'],
        json['nome'],
      );
      var point = layers.data[layercod];
      var lat = point["latitudeTrilha"];
      var lon = point["longitudeTrilha"];
      for (var i = 0; i < (lat as List).length; i++) {
        if (lat[i] == 0.0) {
          line.add([]);
        } else {
          line.last.add(LatLng(lat[i], lon[i]));
        }
      }
      model.polylineCoordinates = line;
      var cods = point["codwp"];
      var latwp = point["latitudeWaypoint"];
      var lonwp = point["longitudeWaypoint"];
      for (var i = 0; i < (cods as List).length; i++) {
        model.waypoints.add(WaypointModel(
            codigo: cods[i], posicao: LatLng(latwp[i], lonwp[i])));
      }
      list.add(model);
      layercod++;
    }

    return list;
  }
}
