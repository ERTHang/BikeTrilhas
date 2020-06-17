import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrilhaRepository {
  final Dio dio;

  TrilhaRepository(this.dio);

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
          json['descricao'],
          json['tipCod']['tipCod'],
          json['difCod']['difCod']);
      for (var regiao in json['regiaoList']) {
        model.regiaoList.add(regiao['regNome']);
      }
      for (var superficie in json['superficieList']) {
        model.superficieList.add(superficie['supNome']);
      }
      for (var bairros in json['bairrosList']) {
        model.bairrosList.add(bairros['baiNome']);
      }
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
