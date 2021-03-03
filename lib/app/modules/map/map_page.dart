import 'dart:async';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/modules/map/Components/custom_search_delegate.dart';
import 'package:biketrilhas_modular/app/modules/map/Services/geolocator_service.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_controller.dart';

class MapPage extends StatefulWidget {
  final String title;
  const MapPage({Key key, this.title = "Map"}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ModularState<MapPage, MapController> {
  final GeolocatorService geoService = GeolocatorService();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  int n = 0;
  bool tracking;
  StreamSubscription<LocationData> subscription;
  Location location = new Location();

  void initState() {
    tracking = false;
    super.initState();
    controller.init();
  }

  List<int> temp = [];
  int routeState = 0;
  int destinos = 0;

  final AuthController auth = Modular.get();

  Widget build(BuildContext context) {
    controller.state = _func;
    return Scaffold(
      key: controller.scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Bike Trilhas',
          style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
        ),
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
                    bottomSheetTrilha(value);
                  });
                  mapController.animateCamera(
                      CameraUpdate.newLatLng(value.polylineCoordinates[0][0]));
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
              if (controller.dataReady.value == null) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Obtendo informações necessárias")
                    ],
                  ),
                );
              }
              controller.getPolylines();
              return _map();
            },
          ),
          // UserRoute
          Positioned(
            bottom: 10,
            right: 10,
            child: ButtonTheme(
              height: 50,
              minWidth: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360)),
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  if (tracking) {
                    controller.createdTrails.add(controller.followRoute);
                    controller.trilhaRepository
                        .saveRoute(controller.followRoute);
                    controller.followRoute = null;
                    subscription.cancel();
                    Modular.to.pushNamed('/usertrail');
                  } else {
                    controller.followRoute =
                        TrilhaModel(2000000 + n, 'followRoute $n');

                    controller.followRoute.polylineCoordinates = [
                      [controller.position.value.target]
                    ];
                    checkPermission(location);
                    subscription =
                        location.onLocationChanged.listen((position) {
                      centerScreen(Position(
                          latitude: position.latitude,
                          longitude: position.longitude));
                      setState(() {
                        controller.followRoute.polylineCoordinates.last
                            .add(LatLng(position.latitude, position.longitude));
                      });
                    });
                  }
                  setState(() {
                    tracking = !tracking;
                  });
                },
                child: Icon(
                  Icons.track_changes,
                  color: (tracking) ? Colors.green : Colors.white,
                  size: 30,
                ),
                elevation: 5,
              ),
            ),
          ),
          // Rota
          Visibility(
            child: Positioned(
              bottom: 0,
              left: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: (routeState == 0) ? 0 : 40,
                // width: (routeState == 0) ? 0 : 100,
                width: 90,
                curve: Curves.easeIn,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(24)),
                  color: (routeState >= 2) ? Colors.red : Colors.blue,
                ),
                child: Center(
                  child: AnimatedCrossFade(
                    firstChild: Text(
                      (routeState == 0) ? '' : 'Origem',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    secondChild: Text(
                      'Destino $destinos',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    crossFadeState: (routeState >= 2)
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
            bottom: 0,
            child: Visibility(
              child: RaisedButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Text(
                  "Criar",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  routeState = 0;
                  controller.trilhasFiltradas = temp;
                  controller.getRoute();
                },
              ),
              visible: routeState > 2,
              maintainSize: false,
              maintainSemantics: false,
              maintainInteractivity: false,
            ),
          ),
          //botao rota
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () {
                controller.routePoints.clear();
                controller.routeMarkers.clear();
                destinos = 0;
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
          ),
          Visibility(
            visible: ADMIN.contains(auth.user.email),
            child: Positioned(
              bottom: 70,
              right: 10,
              child: ButtonTheme(
                height: 50,
                minWidth: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(360)),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    // Modular.to.pushNamed('/photo'); //desabilitado devido à bugs do plugin
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  elevation: 5,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void checkPermission(Location location) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.changeSettings(distanceFilter: 8, interval: 1000);
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
          if (routeState != 0) {
            controller.routeMarkers.add(Marker(
                markerId: MarkerId('destino $routeState'), position: latlng));
            controller.routePoints.add(latlng);
            destinos++;
            routeState++;
          }
        });
      },
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
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

  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19.0)));
  }
}
