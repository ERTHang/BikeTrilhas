import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrilhaModel{
  final int codt;
  final String nome;
  final String descricao;
  List<LatLng> polylineCoordinates = [];

  TrilhaModel(this.codt, this.nome, this.descricao);


}