import 'dart:math';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/storage/shared_prefs.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/Components/trilha_model_json.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/Components/saved_routes.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/Components/saved_trilhas.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrilhaRepository {
  List<int> savedCods = [];
  final Dio dio;
  final SharedPrefs sharedPrefs;
  final AuthController auth;

  TrilhaRepository(this.dio, this.sharedPrefs, this.auth);
  SavedTrilhas savedTrilhas;
  SavedRoutes savedRoutes;
  SavedRoutes recordedTrails;

  int n = 10000;

  void deleteRecordedTrail(int codigo) async {
    if (recordedTrails == null) {
      try {
        recordedTrails =
            SavedRoutes.fromJson(await sharedPrefs.read('recordedTrails'));
      } catch (e) {
        recordedTrails = SavedRoutes([]);
      }
    }
    sharedPrefs.remove('recorded trail $codigo');
    for (var i = 0; i < recordedTrails.codes.length; i++) {
      if (recordedTrails.codes[i] == codigo) {
        recordedTrails.codes.removeAt(i);
      }
    }
    sharedPrefs.remove('recordedTrails');
    sharedPrefs.save('recordedTrails', recordedTrails);
  }

  void deleteRoute(int codigo) {
    sharedPrefs.remove('route $codigo');
    for (var i = 0; i < savedRoutes.codes.length; i++) {
      if (savedRoutes.codes[i] == codigo) {
        savedRoutes.codes.removeAt(i);
      }
    }
    sharedPrefs.remove('savedRoutes');
    sharedPrefs.save('savedRoutes', savedRoutes);
  }

//Deletar trilha
  Future<void> deleteTrail(int codigo) async {
    try {
      savedTrilhas =
          SavedTrilhas.fromJson(await sharedPrefs.read('savedTrilhas'));
    } catch (Exception) {
      savedTrilhas = SavedTrilhas([]);
    }
    sharedPrefs.remove('trilha $codigo');
    for (var i = 0; i < savedTrilhas.codes.length; i++) {
      if (savedTrilhas.codes[i] == codigo) {
        savedTrilhas.codes.removeAt(i);
      }
    }
    await sharedPrefs.remove('savedTrilhas');
    print("Trilha removida!");
    await sharedPrefs.save('savedTrilhas', savedTrilhas);
  }

  Future<List<TrilhaModel>> getRecordedTrails() async {
    List<TrilhaModel> trilhas = [];

    if (recordedTrails == null) {
      try {
        recordedTrails =
            SavedRoutes.fromJson(await sharedPrefs.read('recordedTrails'));
      } catch (e) {
        recordedTrails = SavedRoutes([]);
      }
    }

    for (var i = 0; i < recordedTrails.codes.length; i++) {
      var json =
          await sharedPrefs.read('recorded trail ${recordedTrails.codes[i]}');
      TrilhaModel trilha = TrilhaModel(recordedTrails.codes[i], 'aux');
      var aux = TrilhaModelJson.fromJson(json);
      trilha.fromJson(aux);
      trilhas.add(trilha);
    }
    return trilhas;
  }

  Future<List<TrilhaModel>> getStorageRoutes() async {
    List<TrilhaModel> trilhas = [];
    if (savedRoutes == null) {
      try {
        savedRoutes =
            SavedRoutes.fromJson(await sharedPrefs.read('savedRoutes'));
      } catch (e) {
        savedRoutes = SavedRoutes([]);
      }
    }

    for (var i = 0; i < savedRoutes.codes.length; i++) {
      var json = await sharedPrefs.read('route ${savedRoutes.codes[i]}');
      TrilhaModel trilha = TrilhaModel(savedRoutes.codes[i], 'aux');
      var aux = TrilhaModelJson.fromJson(json);
      trilha.fromJson(aux);
      trilhas.add(trilha);
    }
    return trilhas;
  }

  Future<List<TrilhaModel>> getStorageTrilhas() async {
    print('storage trilhas chamada');
    List<TrilhaModel> trilhas = [];

    if (savedTrilhas == null) {
      try {
        print('saved trilhas eh nulo');
        savedTrilhas =
            SavedTrilhas.fromJson(await sharedPrefs.read('savedTrilhas'));
      } catch (e) {
        print(e);
        savedTrilhas = SavedTrilhas([]);
      }
    }

    for (var i = 0; i < savedTrilhas.codes.length; i++) {
      var json = await sharedPrefs.read('trilha ${savedTrilhas.codes[i]}');
      TrilhaModel trilha = TrilhaModel(savedTrilhas.codes[i], 'aux');
      var aux = TrilhaModelJson.fromJson(json);
      trilha.fromJson(aux);
      trilhas.add(trilha);
      savedCods.add(trilha.codt);
    }
    return trilhas;
  }

  isSaved(int codTrilha) async {
    for (int i = 0; i < savedCods.length; i++) {
      if (codTrilha == savedCods.elementAt(i)) {
        return true;
      }
    }
  }

  Future<List<int>> getTrilhasUser() async {
    List<int> codts = [];
    var email = auth.user.email;
    final value = await dio.get("/server/trilhauser/$email");
    for (var item in (value.data as List)) {
      codts.add(item['cod']);
    }
    return codts;
  }

  Future<bool> deleteTrilhaUser(int codt) async {
    final value = await dio.delete("/server/trilha/$codt");
    return value.data == 'true';
  }

  Future<bool> deleteWaypointUser(int codwp, int codt) async {
    final value = await dio.delete("/server/waypoint/$codwp/$codt");
    return value.data == 'true';
  }

  Future<TrilhaModel> getRoute(List<LatLng> routePoints) async {
    List<List<LatLng>> rotaPolyline = [];
    var username = auth.user.displayName.toLowerCase();
    TrilhaModel model = TrilhaModel(n, 'Rota gerada por $username');

    for (var i = 0; i < routePoints.length - 1; i++) {
      rotaPolyline.add([]);
      n++;
      bool reversed;
      var codt = (await dio.get('/server/route', queryParameters: {
        "lat_orig": routePoints[i].latitude,
        "lon_orig": routePoints[i].longitude,
        "lat_dest": routePoints[i + 1].latitude,
        "lon_dest": routePoints[i + 1].longitude
      }))
          .data;

      var point = (await dio.get('/server/temp/$codt')).data;

      if (point == "") {
        return null;
      }

      var lat = point["latitudeTrilha"] as List;
      var lon = point["longitudeTrilha"] as List;
      if (lat.isNotEmpty && isFirstPoint(lat, routePoints, i, lon)) {
        lat.insert(0, routePoints[i].latitude);
        lon.insert(0, routePoints[i].longitude);
        reversed = false;
      } else {
        lat.insert(0, routePoints[i + 1].latitude);
        lon.insert(0, routePoints[i + 1].longitude);
        reversed = true;
      }
      for (var j = 0; j < lat.length; j++) {
        rotaPolyline.last.add(LatLng(lat[j], lon[j]));
      }
      rotaPolyline.last.add((reversed) ? routePoints[i] : routePoints[i + 1]);
      lat.add(
          (reversed) ? routePoints[i].latitude : routePoints[i + 1].latitude);
      lon.add(
          (reversed) ? routePoints[i].longitude : routePoints[i + 1].longitude);
      model.waypoints.addAll([
        WaypointModel(
          codigo: n,
          posicao: routePoints[i],
        ),
        WaypointModel(
          codigo: 2 * n,
          posicao: routePoints[i + 1],
        )
      ]);
    }
    model.polylineCoordinates = rotaPolyline;
    await saveRoute(model);
    return model;
  }

  bool isFirstPoint(List lat, List<LatLng> routePoints, int i, List lon) {
    return sqrt(pow(lat[0] - routePoints[i].latitude, 2) +
            pow(lon[0] - routePoints[i].longitude, 2)) <
        sqrt(pow(lat[0] - routePoints[i + 1].latitude, 2) +
            pow(lon[0] - routePoints[i + 1].longitude, 2));
  }

  Future saveRecordedTrail(TrilhaModel model) async {
    if (recordedTrails == null) {
      try {
        recordedTrails =
            SavedRoutes.fromJson(await sharedPrefs.read('recordedTrails'));
      } catch (Exception) {
        recordedTrails = SavedRoutes([]);
      }
    }

    var numero = model.codt;

    TrilhaModelJson trilha = model.toJson();
    sharedPrefs.save('recorded trail $numero', trilha.toJson());

    recordedTrails.codes.add(numero);
    try {
      sharedPrefs.remove('recordedTrails');
    } catch (e) {}
    sharedPrefs.save('recordedTrails', recordedTrails);
  }

  Future saveRoute(TrilhaModel model) async {
    if (savedRoutes == null) {
      try {
        savedRoutes =
            SavedRoutes.fromJson(await sharedPrefs.read('savedRoutes'));
      } catch (Exception) {
        savedRoutes = SavedRoutes([]);
      }
    }

    var numero = (savedRoutes.codes.isEmpty) ? 0 : savedRoutes.codes.last + 1;
    model.codt = numero;

    TrilhaModelJson trilha = model.toJson();
    sharedPrefs.save('route $numero', trilha.toJson());

    savedRoutes.codes.add(numero);
    try {
      sharedPrefs.remove('savedRoutes');
    } catch (e) {}
    sharedPrefs.save('savedRoutes', savedRoutes);
  }

  Future saveTrilha(TrilhaModel model) async {
    if (savedTrilhas == null) {
      try {
        print('savedtrilhas = null na hora de salvar');
        savedTrilhas =
            SavedTrilhas.fromJson(await sharedPrefs.read('savedTrilhas'));
      } catch (Exception) {
        savedTrilhas = SavedTrilhas([]);
      }
    }

    var numero = model.codt;

    TrilhaModelJson trilha = model.toJson();
    sharedPrefs.save('trilha $numero', trilha.toJson());

    savedTrilhas.codes.add(numero);
    try {
      sharedPrefs.remove('savedTrilhas');
    } catch (e) {}
    sharedPrefs.save('savedTrilhas', savedTrilhas);
  }

  Future<List<TrilhaModel>> getAllTrilhas() async {
    List<TrilhaModel> list = [];
    try {
      var cods = await dio.get("/server/cods");
      var layercod = 0;
      var response = await dio.get("/server/trilhadados");
      var layers = await dio.put("/server/layer",
          data: {"codt": (cods.data as List)}).timeout(Duration(seconds: 5));

      for (var json in (response.data as List)) {
        List<List<LatLng>> line = [];
        TrilhaModel model = TrilhaModel(
          json['codt'],
          json['nome'],
        );
        var point = layers.data[layercod];
        var lat = point["latitudeTrilha"];
        var lon = point["longitudeTrilha"];
        for (var i = 0; i < lat.length; i++) {
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
    } catch (e) {}
    return list;
  }

  Future<List<TrilhaModel>> getUpdatedTrilhas() async {
    var cods = (await dio.get('/server/update/${auth.user.email}')).data;
    if (cods.isEmpty) {
      return null;
    }
    List<dynamic> codsfinal = [];
    codsfinal.addAll(cods);

    List<TrilhaModel> list = [];
    List<String> nomes = [];
    var layercod = 0;
    for (var cod in cods) {
      if (cod < 0) {
        if (mapController.trilhas.value.contains(cod)) {
          mapController.trilhas.value
              .removeWhere((element) => element.codt == cod);
        }
        codsfinal.remove(cod);
      } else {
        nomes.add((await dio.get('/server/naogeografico',
                queryParameters: {"tipo": "trilha", "cod": cod}))
            .data[0]['nome']);
      }
    }
    var layers = await dio.put("/server/layer",
        data: {"codt": codsfinal}).timeout(Duration(seconds: 5));

    for (var i = 0; i < codsfinal.length; i++) {
      List<List<LatLng>> line = [];
      TrilhaModel model = TrilhaModel(
        codsfinal[i],
        nomes[i],
      );
      var point = layers.data[layercod];
      var lat = point["latitudeTrilha"];
      var lon = point["longitudeTrilha"];
      for (var i = 0; i < lat.length; i++) {
        if (lat[i] == 0.0) {
          line.add([]);
        } else {
          line.last.add(LatLng(lat[i], lon[i]));
        }
      }
      model.polylineCoordinates = line;
      var codwp = point["codwp"];
      var latwp = point["latitudeWaypoint"];
      var lonwp = point["longitudeWaypoint"];
      for (var i = 0; i < (codwp as List).length; i++) {
        model.waypoints.add(WaypointModel(
            codigo: codwp[i], posicao: LatLng(latwp[i], lonwp[i])));
      }
      list.add(model);
      layercod++;
    }
    return list;
  }
}
