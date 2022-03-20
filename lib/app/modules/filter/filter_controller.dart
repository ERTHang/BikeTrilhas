import 'package:biketrilhas_modular/app/modules/filter/filter_page.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:biketrilhas_modular/app/shared/filter/filter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

part 'filter_controller.g.dart';

class FilterController = _FilterControllerBase with _$FilterController;

abstract class _FilterControllerBase with Store {
  final FilterRepository filterRepository;
  final MapController mapController;
  final DrawerClassController drawerClassController;
  int value;

  _FilterControllerBase(
      this.filterRepository, this.mapController, this.drawerClassController) {
    value = mapController.typeNum;
  }

  filtrar(List<Item> _data, FilterController controller,
      BuildContext context) async {
    final List<int> regiao = [];
    final List<int> bairro = [];
    final List<int> superficie = [];
    final List<int> categoria = [];
    final List<int> subtipo = [];

    for (var i = 0; i < _data[2].booleans.length; i++) {
      if (_data[2].booleans[i]) {
        regiao.add(i + 1);
      }
    }

    /* 
    for (var i = 0; i < _data[3].booleans.length; i++) {
      if (_data[3].booleans[i]) {
        bairro.add(i + 1);
      }
    }
    */

    for (var i = 0; i < _data[4].booleans.length; i++) {
      if (_data[4].booleans[i]) {
        superficie.add(i + 1);
      }
    }

    for (var i = 0; i < _data[5].booleans.length; i++) {
      if (_data[5].booleans[i]) {
        categoria.add(i + 1);
      }
    }

    for (var i = 0; i < _data[1].booleans.length; i++) {
      if (_data[1].booleans[i]) {
        subtipo.add(i + 1);
      }
    }

    var filtros = await filterRepository.getFiltered([_data[0].modified],
        [_data[6].modified], regiao, bairro, superficie, categoria, subtipo);
    if (superficie.isNotEmpty ||
        bairro.isNotEmpty ||
        categoria.isNotEmpty ||
        regiao.isNotEmpty ||
        subtipo.isNotEmpty ||
        _data[6].modified != 0) {
      mapController.filtrar(
          filtros, false, value != mapController.typeNum, value);
    } else {
      mapController.filtrar(
          filtros, true, value != mapController.typeNum, value);
    }

    mapController.getPolylines();
    mapController.state();

    Navigator.pop(context);
    //Modular.to.popUntil((route) => route.isFirst);

    drawerClassController.value = 0;
  }
}
