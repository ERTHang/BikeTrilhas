import 'dart:async';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
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
    store.state = _func;
    store.getPolylines();
    return Scaffold(
        key: store.scaffoldState,
        appBar: AppBar(
          title: Text(
            'Suas Trilhas',
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
                });
              },
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              polylines: store.polylines,
              markers: (routeState == 0) ? store.markers : store.routeMarkers,
              mapType: MapType.normal,
              initialCameraPosition: (mapController.followTrail != null)
                  ? CameraPosition(
                      target: mapController.followTrail.polylineCoordinates[0]
                          [0],
                      zoom: 14)
                  : store.mapController.position.value,
              onMapCreated: (GoogleMapController mapcontroller) {
                if (store.tappedTrilha != null) {
                  store.uploadTrilha(context, store.mapController.followTrail);
                  bottomSheetTempTrail(store.mapController.followTrail,
                      store.scaffoldState, store.state);
                }
                _controller.complete(mapcontroller);
              },
            ),
          ],
        ));
  }

  void _func() {
    setState(() {});
  }
}
