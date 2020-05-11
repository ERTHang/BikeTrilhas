import 'dart:async';

import 'package:biketrilhas_modular/app/modules/map/Components/drawer/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_controller.dart';

class MapPage extends StatefulWidget {
  final String title;
  const MapPage({Key key, this.title = "Map"}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ModularState<MapPage, MapController> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  CameraPosition _position;
  Future<Position> _futurePosition;

  void initState() {
    super.initState();

    _futurePosition = geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .timeout(Duration(seconds: 10))
        .then((Position position) {
      setState(() {
        _position = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15);
      });
      return position;
    }).catchError(
      (e) {
        Modular.to.pushReplacementNamed('/map/error');
      },
    );
  }

  //controller - não sei o funcionamento dele ainda, mas o google maps me obriga a usar
  Completer<GoogleMapController> _controller = Completer();

  //posição do usuário obtida no início do app

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Bike Trilhas'),
          centerTitle: true,
        ),
        drawer: DrawerClass(),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            FutureBuilder<Position>(
              future: _futurePosition,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _map();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
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
                ))
          ],
        ));
  }

  Widget _map() {
    if (_position == null) {
      return Container();
    }
    return GoogleMap(
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: _position,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
