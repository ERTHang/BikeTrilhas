import 'dart:async';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'userroutes_controller.dart';

class UserroutesPage extends StatefulWidget {
  final String title;
  const UserroutesPage({Key key, this.title = "Userroutes"}) : super(key: key);

  @override
  _UserroutesPageState createState() => _UserroutesPageState();
}

class _UserroutesPageState
    extends ModularState<UserroutesPage, UserroutesController> {
  Completer<GoogleMapController> _controller = Completer();
  int routeState = 0, destinos = 0;

  @override
  Widget build(BuildContext context) {
    store.state = _func;
    store.getPolylines();
    return Scaffold(
        key: store.scaffoldState,
        appBar: AppBar(
          title: Text(
            'Suas Rotas',
            style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              onTap: (latlng) {
                setState(() {
                  if (store.mapController.sheet != null) {
                    store.mapController.sheet.close();
                    store.mapController.sheet = null;
                    store.tappedTrilha = null;
                  }
                  if (store.mapController.nameSheet != null) {
                    store.mapController.nameSheet.close();
                    store.mapController.nameSheet = null;
                    store.tappedTrilha = null;
                  }
                  if (routeState != 0) {
                    store.routeMarkers.add(Marker(
                        markerId: MarkerId('destino $routeState'),
                        position: latlng));
                    store.routePoints.add(latlng);
                    destinos++;
                    routeState++;
                  }
                });
              },
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              polylines: store.polylines,
              markers: (routeState == 0) ? store.markers : store.routeMarkers,
              mapType: MapType.normal,
              initialCameraPosition: (mapController.newTrail != null)
                  ? CameraPosition(
                      target: mapController.newTrail.waypoints[0].posicao,
                      zoom: 14)
                  : store.mapController.position.value,
              onMapCreated: (GoogleMapController mapcontroller) {
                if (store.tappedTrilha != null) {
                  bottomSheetTempTrail(store.mapController.newTrail,
                      store.scaffoldState, store.state);
                }
                store.mapController.newTrail = null;
                _controller.complete(mapcontroller);
              },
            ),
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
                  if (store.mapController.sheet != null) {
                    store.mapController.sheet.close();
                    store.mapController.sheet = null;
                    store.tappedTrilha = null;
                  }
                  if (store.mapController.nameSheet != null) {
                    store.mapController.nameSheet.close();
                    store.mapController.nameSheet = null;
                    store.tappedTrilha = null;
                  }
                  if (routeState == 0) {
                    setState(() {
                      routeState = 1;
                    });
                  } else {
                    setState(() {
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
          ],
        ));
  }

  void _func() {
    setState(() {});
  }
}
