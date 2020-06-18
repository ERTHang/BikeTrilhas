import 'dart:async';

import 'package:biketrilhas_modular/app/modules/map/Components/custom_search_delegate.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_controller.dart';

class MapPage extends StatefulWidget {
  final String title;
  const MapPage({Key key, this.title = "Map"}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ModularState<MapPage, MapController> {
  void initState() {
    super.initState();
    controller.init();
  }

  Completer<GoogleMapController> _controller = Completer();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Bike Trilhas'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(controller));
              }),
          Visibility(
            child: IconButton(
                icon: Icon(Icons.delete_sweep, color: Colors.red),
                onPressed: () {
                  setState(() {
                    controller.trilhasFiltradas = [];
                    controller.getPolylines();
                  });
                }),
            visible: (controller.trilhasFiltradas.isNotEmpty),
          )
        ],
      ),
      drawer: Scaffold(
        backgroundColor: Colors.transparent,
        body: DrawerPage(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Observer(
            builder: (_) {
              if (controller.position.error != null) {
                return Center(
                  child: Text("error getting position"),
                );
              }
              if (controller.trilhas.error != null) {
                return Center(
                  child: Text("error getting trilhas"),
                );
              }
              if (controller.position.value == null) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Obtendo posição do usuário")
                    ],
                  ),
                );
              }
              if (controller.trilhas.value == null) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Obtendo trilhas salvas")
                    ],
                  ),
                );
              }
              controller.getPolylines();
              return _map();
            },
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: ButtonTheme(
              height: 60,
              minWidth: 60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360)),
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  Modular.to.pushNamed('/photo');
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 40,
                ),
                elevation: 5,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _map() {
    if (controller.position == null) {
      return Container();
    }
    return GoogleMap(
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      polylines: controller.polylines,
      markers: controller.markers,
      mapType: MapType.normal,
      initialCameraPosition: controller.position.value,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
