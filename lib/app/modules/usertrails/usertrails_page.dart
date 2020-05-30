import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suas Trilhas'),
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
