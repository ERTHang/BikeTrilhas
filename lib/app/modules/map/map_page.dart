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
import 'package:connectivity/connectivity.dart';

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
  bool tracking, changeButton = false, paused = false;
  StreamSubscription<LocationData> subscription;
  Location location = new Location();

  void initState() {
    tracking = false;
    super.initState();
    store.init();
  }

  List<int> temp = [];
  int routeState = 0;
  int destinos = 0;

  final AuthController auth = Modular.get();

  Widget build(BuildContext context) {
    store.state = _func;
    return Scaffold(
      key: store.scaffoldState,
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
                        context: context, delegate: CustomSearchDelegate(store))
                    .then((value) {
                  store.getPolylines();
                  setState(() {
                    store.tappedTrilha = value.codt;
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
                    store.filterClear = false;
                    store.trilhasFiltradas = store.typeFilter;
                    store.getPolylines();
                  });
                }),
            visible: (store.filterClear),
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
              checkPermission(location);
              if (store.position.error != null) {
                return Center(
                  child: Text("error getting position"),
                );
              }
              if (store.position.value == null) {
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
              if (store.trilhas.error != null) {
                print(store.trilhas.error);
                return _map();
              }
              if (store.trilhas.value == null) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Obtendo trilhas")
                    ],
                  ),
                );
              }
              store.getPolylines();
              return _map();
            },
          ),
          //StopButton
          AnimatedPositioned(
            bottom: 10,
            right: changeButton ? 145.0 : 10.0,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(50, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(360))),
              ),
              onPressed: () {
                setState(() {
                  tracking = false;
                  changeButton = false;
                  paused = false;
                });
                subscription.cancel();
                store.nomeTrilha(context);
              },
              child: Icon(Icons.stop),
            ),
          ),
          //PauseButton
          AnimatedPositioned(
            bottom: 10,
            right: changeButton ? 80.0 : 10.0,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(50, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(360))),
              ),
              onPressed: () {
                if (paused) {
                  subscription.pause();
                } else {
                  store.followTrail.polylineCoordinates.add([]);
                  subscription.resume();
                }
                setState(() {
                  paused = !paused;
                });
              },
              child: (!paused) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            ),
          ),

          // UserRoute
          Positioned(
            bottom: 10,
            right: 10,
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(50, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                elevation: MaterialStateProperty.all(5),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(360))),
              ),
              onPressed: () {
                if (tracking) {
                  setState(() {
                    changeButton = !changeButton;
                  });
                } else {
                  store.followTrail =
                      TrilhaModel(2000000 + n, 'followRoute $n');

                  store.followTrail.polylineCoordinates = [
                    [store.position.value.target]
                  ];
                  checkPermission(location);
                  subscription = location.onLocationChanged.listen((position) {
                    // ignore: missing_required_param
                    centerScreen(Position(
                        latitude: position.latitude,
                        longitude: position.longitude));
                    setState(() {
                      store.followTrail.polylineCoordinates.last
                          .add(LatLng(position.latitude, position.longitude));
                    });
                  });
                  setState(() {
                    tracking = !tracking;
                  });
                }
              },
              child: Icon(
                Icons.track_changes,
                color: (tracking)
                    ? ((paused) ? Colors.red : Colors.green)
                    : Colors.white,
                size: 30,
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
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                child: Text(
                  "Criar",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  routeState = 0;
                  store.trilhasFiltradas = temp;
                  store.getRoute();
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
                store.routePoints.clear();
                store.routeMarkers.clear();
                destinos = 0;
                if (store.sheet != null) {
                  store.sheet.close();
                  store.sheet = null;
                  store.tappedTrilha = null;
                  store.tappedWaypoint = null;
                }
                if (store.nameSheet != null) {
                  store.nameSheet.close();
                  store.nameSheet = null;
                  store.tappedTrilha = null;
                  store.tappedWaypoint = null;
                }
                if (routeState == 0) {
                  setState(() {
                    temp = store.trilhasFiltradas;
                    store.trilhasFiltradas = [0];
                    routeState = 1;
                  });
                } else {
                  setState(() {
                    store.trilhasFiltradas = temp;
                    store.getPolylines();
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
            visible: admin == 1,
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
                    Modular.to.pushNamed('/fotos');
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
    if (store.position == null) {
      return Container();
    }
    return GoogleMap(
      onTap: (latlng) {
        setState(() {
          if (store.sheet != null) {
            store.sheet.close();
            store.sheet = null;
            store.tappedTrilha = null;
            store.tappedWaypoint = null;
          }
          if (store.nameSheet != null) {
            store.nameSheet.close();
            store.nameSheet = null;
            store.tappedTrilha = null;
            store.tappedWaypoint = null;
          }
          if (routeState != 0) {
            store.routeMarkers.add(Marker(
                markerId: MarkerId('destino $routeState'), position: latlng));
            store.routePoints.add(latlng);
            destinos++;
            routeState++;
          }
        });
      },
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      polylines: store.polylines,
      markers: (routeState == 0) ? store.markers : store.routeMarkers,
      mapType: MapType.normal,
      initialCameraPosition: store.position.value,
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

  await(Future<ConnectivityResult> checkConnectivity) {}
}
