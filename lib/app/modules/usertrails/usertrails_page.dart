import 'dart:async';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'usertrails_controller.dart';

class UsertrailsPage extends StatefulWidget {
  final String title;
  const UsertrailsPage({Key key, this.title = "Usertrails"}) : super(key: key);

  @override
  _UsertrailsPageState createState() => _UsertrailsPageState();
}

class _UsertrailsPageState
    extends ModularState<UsertrailsPage, UsertrailsController> {
  Completer<GoogleMapController> _controller = Completer();
  int routeState = 0, destinos = 0;

  @override
  Widget build(BuildContext context) {
    controller.state = _func;
    controller.getPolylines();
    return Scaffold(
        key: controller.scaffoldState,
        appBar: AppBar(
          title: Text('Suas Rotas'),
          centerTitle: true,
        ),
        drawer: Scaffold(
          backgroundColor: Colors.transparent,
          body: DrawerPage(),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              onTap: (latlng) {
                setState(() {
                  if (controller.mapController.sheet != null) {
                    controller.mapController.sheet.close();
                    controller.mapController.sheet = null;
                    controller.tappedTrilha = null;
                  }
                  if (controller.mapController.nameSheet != null) {
                    controller.mapController.nameSheet.close();
                    controller.mapController.nameSheet = null;
                    controller.tappedTrilha = null;
                  }
                  if (routeState != 0) {
                    controller.routeMarkers.add(Marker(
                        markerId: MarkerId('destino $routeState'),
                        position: latlng));
                    controller.routePoints.add(latlng);
                    destinos++;
                    routeState++;
                  }
                });
              },
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              polylines: controller.polylines,
              markers: (routeState == 0) ? controller.markers : controller.routeMarkers,
              mapType: MapType.normal,
              initialCameraPosition: controller.mapController.position.value,
              onMapCreated: (GoogleMapController mapcontroller) {
                if (controller.tappedTrilha != null) {
                  bottomSheetTempTrail(controller.mapController.newTrail,
                      controller.scaffoldState, controller.state);
                }
                controller.mapController.newTrail = null;
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
                  if (controller.mapController.sheet != null) {
                    controller.mapController.sheet.close();
                    controller.mapController.sheet = null;
                    controller.tappedTrilha = null;
                  }
                  if (controller.mapController.nameSheet != null) {
                    controller.mapController.nameSheet.close();
                    controller.mapController.nameSheet = null;
                    controller.tappedTrilha = null;
                  }
                  if (routeState == 0) {
                    setState(() {
                      routeState = 1;
                    });
                  } else {
                    setState(() {
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
          ],
        ));
  }

  void _func() {
    setState(() {});
  }
}
