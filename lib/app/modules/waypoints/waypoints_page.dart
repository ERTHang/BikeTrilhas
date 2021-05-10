import 'dart:async';

import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'waypoints_controller.dart';

class WaypointsPage extends StatefulWidget {
  final String title;
  const WaypointsPage({Key key, this.title = "Waypoints"}) : super(key: key);

  @override
  _WaypointsPageState createState() => _WaypointsPageState();
}

class _WaypointsPageState
    extends ModularState<WaypointsPage, WaypointsController> {
  Completer<GoogleMapController> _controller = Completer();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sinalizações'),
        centerTitle: true,
      ),
      drawer: Scaffold(
        backgroundColor: Colors.transparent,
        body: DrawerPage(),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: controller.mapController.position.value,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
