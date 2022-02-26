import 'dart:async';
import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:background_location/background_location.dart' as bglocation;
import 'package:biketrilhas_modular/app/modules/map/Components/custom_search_delegate.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_controller.dart';

class MapPage extends StatefulWidget {
  final String title;
  final CameraPosition position;
  const MapPage({Key key, this.title = "Map", this.position}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ModularState<MapPage, MapController> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  int n = 0;
  bool tracking, changeButton = false, paused = false;
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
    store.position = widget.position;
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
          Visibility(
            child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(store))
                      .then((value) {
                    store.getPolylines();
                    setState(() {
                      store.tappedTrilha = value.codt;
                      bottomSheetTrilha(value);
                    });
                    mapController.animateCamera(CameraUpdate.newLatLng(
                        value.polylineCoordinates[0][0]));
                  });
                }),
            visible: (widget.position != null),
          ),
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
          /* Observer para verificar a posição do usuário e a conexão com o 
           * servidor, caso tenha os dois irá para o Google Maps na função
           * _map() 
           */
          Observer(
            builder: (context) {
              if (widget.position == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Erro ao obter localização"),
                    ),
                    Center(
                      child: Text(
                          "Abra o menu->configurações para habilitar a localização"),
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
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

          //Botão para terminar a criação de trilhas
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
              onLongPress: () async {
                if (admin == 1) {
                  var location = await Geolocator.getCurrentPosition();
                  setState(() {
                    store.followTrail.polylineCoordinates.last.add(
                        LatLng(location.latitude + 0.002, location.longitude));
                    store.followTrail.polylineCoordinates.last.add(LatLng(
                        location.latitude + 0.002, location.longitude + 0.002));
                    store.followTrail.polylineCoordinates.last.add(
                        LatLng(location.latitude, location.longitude + 0.002));
                    store.followTrail.polylineCoordinates.last
                        .add(LatLng(location.latitude, location.longitude));
                  });
                }
              },
              onPressed: () {
                setState(() {
                  tracking = false;
                  changeButton = false;
                  paused = false;
                });
                bglocation.BackgroundLocation.stopLocationService();
                store.nomeTrilha(context);
              },
              child: Icon(Icons.stop),
            ),
          ),

          //Botão para pausar a criação de trilhas
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
                if (!paused) {
                  bglocation.BackgroundLocation.stopLocationService();
                } else {
                  store.followTrail.polylineCoordinates.add([]);
                  bglocation.BackgroundLocation.startLocationService(
                      distanceFilter: 6);
                }
                setState(() {
                  paused = !paused;
                });
              },
              child: (!paused) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            ),
          ),

          // Botão para criação de trilhas
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
                      TrilhaModel(store.nextCodt(), 'followRoute $n');
                  n++;

                  store.followTrail.polylineCoordinates = [[]];
                  addInitialLocation(
                      store.followTrail.polylineCoordinates.last);
                  bglocation.BackgroundLocation.getPermissions(
                    onGranted: () {
                      bglocation.BackgroundLocation.setAndroidNotification(
                        title: "Gravando trilha",
                        message:
                            "Estamos obtendo sua localização para gravar a trilha",
                      );
                      bglocation.BackgroundLocation.startLocationService(
                          distanceFilter: 6);
                      bglocation.BackgroundLocation.getLocationUpdates(
                          (bglocation.Location location) {
                        // ignore: missing_required_param
                        centerScreen(Position(
                            longitude: location.longitude,
                            latitude: location.latitude));
                        setState(() {
                          store.followTrail.polylineCoordinates.last.add(
                              LatLng(location.latitude, location.longitude));
                        });
                      });
                    },
                    onDenied: () {
                      alert(context, "Permissões negedas, impossível continuar",
                          'Permissões');
                    },
                  );
                  setState(() {
                    tracking = !tracking;
                  });
                }
              },
              child: Icon(
                Icons.track_changes,
                color: (tracking)
                    ? ((paused) ? Colors.yellow : Colors.green)
                    : Colors.white,
                size: 30,
              ),
            ),
          ),

          // Container para o texto de origem e destino da rota
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

          // Botão para encerrar a criação de rotas quando a origem e destino
          // estiverem definidos
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

          //botão para iniciar a criação de uma rota
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

          //Botão para tirar uma foto para um waypoint
          Visibility(
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

  // verificar as permissões de localização do usuário
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

  // atualização do estado da página de mapas fora da classe
  void _func() {
    setState(() {});
  }

  // mapa do aplicativo
  Widget _map() {
    if (store.position == null) {
      return Container();
    }
    return GoogleMap(
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      polylines: store.polylines,
      markers: (routeState == 0) ? store.markers : store.routeMarkers,
      mapType: MapType.normal,
      initialCameraPosition: widget.position,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        mapController = controller;
      },
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
    );
  }

  //utilizado na gravação de uma nova trilha
  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19.0)));
  }
}

addInitialLocation(List<LatLng> lista) async {
  Geolocator.getCurrentPosition()
      .then((value) => lista.add(LatLng(value.latitude, value.longitude)));
}
