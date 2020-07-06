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

  List<int> temp = [];
  int routeState = 0;

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  Widget build(BuildContext context) {
    controller.state = _func;
    return Scaffold(
      key: controller.scaffoldState,
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
                        delegate: CustomSearchDelegate(controller))
                    .then((value) {
                  controller.getPolylines();
                  setState(() {
                    controller.tappedTrilha = value.codt;
                    controller.bottomSheetTrilha(value.codt);
                  });
                  mapController.animateCamera(
                      CameraUpdate.newLatLng(value.polylineCoordinates[0]));
                });
              }),
          Visibility(
            child: IconButton(
                icon: Icon(Icons.delete_sweep, color: Colors.red),
                onPressed: () {
                  setState(() {
                    controller.filterClear = false;
                    controller.trilhasFiltradas = controller.typeFilter;
                    controller.getPolylines();
                  });
                }),
            visible: (controller.filterClear),
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
            builder: (context) {
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
          Visibility(
            child: Positioned(
              bottom: 5,
              left: (MediaQuery.of(context).size.width / 2) - 50,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: (routeState == 0) ? 0 : 50,
                // width: (routeState == 0) ? 0 : 100,
                width: 100,
                curve: Curves.easeIn,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: (routeState == 2) ? Colors.red : Colors.blue,
                ),
                child: Center(
                  child: AnimatedCrossFade(
                    firstChild: Text(
                      (routeState == 0) ? '' : 'Origem',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    secondChild: Text(
                      'Destino',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    crossFadeState: (routeState == 2)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 500),
                  ),
                ),
              ),
            ),
            maintainState: false,
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () {
                if (controller.sheet != null) {
                  controller.sheet.close();
                  controller.sheet = null;
                  controller.tappedTrilha = null;
                  controller.tappedWaypoint = null;
                }
                if (controller.nameSheet != null) {
                  controller.nameSheet.close();
                  controller.nameSheet = null;
                  controller.tappedTrilha = null;
                  controller.tappedWaypoint = null;
                }
                if (routeState == 0) {
                  setState(() {
                    temp = controller.trilhasFiltradas;
                    controller.trilhasFiltradas = [0];
                    routeState = 1;
                  });
                } else {
                  setState(() {
                    controller.trilhasFiltradas = temp;
                    controller.getPolylines();
                    routeState = 0;
                  });
                }
              },
              icon: Icon(
                (routeState == 0) ? Icons.directions : Icons.close,
                color: (routeState == 0) ? Colors.blue : Colors.red,
                size: 40,
              ),
            ),
          )
          // Positioned(
          //   bottom: 30,
          //   left: 30,
          //   child: ButtonTheme(
          //     height: 60,
          //     minWidth: 60,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(360)),
          //     child: RaisedButton(
          //       color: Colors.blue,
          //       onPressed: () {
          //         Modular.to.pushNamed('/photo');
          //       },
          //       child: Icon(
          //         Icons.camera_alt,
          //         color: Colors.white,
          //         size: 40,
          //       ),
          //       elevation: 5,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  void _func() {
    setState(() {});
  }

  Widget _map() {
    if (controller.position == null) {
      return Container();
    }
    return GoogleMap(
      onTap: (latlng) {
        setState(() {
          if (controller.sheet != null) {
            controller.sheet.close();
            controller.sheet = null;
            controller.tappedTrilha = null;
            controller.tappedWaypoint = null;
          }
          if (controller.nameSheet != null) {
            controller.nameSheet.close();
            controller.nameSheet = null;
            controller.tappedTrilha = null;
            controller.tappedWaypoint = null;
          }
          if (routeState == 2) {
            controller.routeMarkers.clear();
            controller.routeDest = latlng;
            controller.trilhasFiltradas = temp;
            controller.getRoute();
            routeState = 0;
          }
          if (routeState == 1) {
            controller.routeMarkers.add(Marker(markerId: MarkerId('inicio'), position: latlng));
            controller.routeOrig = latlng;
            routeState = 2;
          }
        });
      },
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      polylines: controller.polylines,
      markers: (routeState == 0) ? controller.markers : controller.routeMarkers,
      mapType: MapType.normal,
      initialCameraPosition: controller.position.value,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        mapController = controller;
      },
    );
  }
}
