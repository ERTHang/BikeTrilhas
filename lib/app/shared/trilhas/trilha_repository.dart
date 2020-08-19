import 'dart:math';

import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrilhaRepository {
  final Dio dio;

  TrilhaRepository(this.dio);

  int n = 10000;

  Future<TrilhaModel> getRoute(LatLng origem, LatLng destino) async {
    final auth = Modular.get<AuthController>();
    bool reversed;
    var codt = (await dio.get('/server/route', queryParameters: {
      "lat_orig": origem.latitude,
      "lon_orig": origem.longitude,
      "lat_dest": destino.latitude,
      "lon_dest": destino.longitude
    }))
        .data;

    var response = (await dio.get('/server/temp/$codt'));
    var point = response.data;
    var username = auth.user.displayName.toLowerCase();
    n++;
    TrilhaModel model = TrilhaModel(codt + n, 'Rota gerada por $username');
    var lat = point["latitudeTrilha"];
    var lon = point["longitudeTrilha"];
    if ((lat as List).isNotEmpty &&
        sqrt(pow(lat[0] - origem.latitude, 2) +
                pow(lon[0] - origem.longitude, 2)) <
            sqrt(pow(lat[0] - destino.latitude, 2) +
                pow(lon[0] - destino.longitude, 2))){
                  model.polylineCoordinates.add(origem);
                  reversed = false;
                }
                else{
                  model.polylineCoordinates.add(destino);
                  reversed = true;
                }
    for (var i = 0; i < (lat as List).length; i++) {
      model.polylineCoordinates.add(LatLng(lat[i], lon[i]));
    }
    if (reversed) {
      model.polylineCoordinates.add(origem);
    }
    else{
      model.polylineCoordinates.add(destino);
    }
    model.waypoints.addAll([
      WaypointModel(
        codigo: codt + n,
        posicao: origem,
      ),
      WaypointModel(
        codigo: 2 * (codt + n),
        posicao: destino,
      )
    ]);
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
      TrilhaModel model = TrilhaModel(
        json['codt'],
        json['nome'],
      );
      var point = layers.data[layercod];
      var lat = point["latitudeTrilha"];
      var lon = point["longitudeTrilha"];
      for (var i = 0; i < (lat as List).length; i++) {
        model.polylineCoordinates.add(LatLng(lat[i], lon[i]));
      }
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
