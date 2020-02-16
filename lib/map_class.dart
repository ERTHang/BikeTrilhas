import 'package:flutter/material.dart';

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Components/Drawer.dart';


class MapClass extends StatefulWidget {
  _MapClassState createState() => _MapClassState();
}

class _MapClassState extends State<MapClass> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _position;


  Widget build(BuildContext context) {
    if(_position == null)
      _getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Bike Trilhas'),
        centerTitle: true,
      ),
      drawer: DrawerClass(),
      body: _map()
    );
  }

  Widget _map(){
    if (_position == null) {
      return null;
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

  _getCurrentLocation(){ 
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then((Position position) {
              setState((){
                _position = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 15);
              });
            }).catchError((e) {
              print(e);
            });
  }
}


