import 'package:flutter/material.dart';

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'login_page.dart';


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
        backgroundColor: Colors.green[700],
        title: Text('Bike Trilhas'),
        centerTitle: true,
      ),
      drawer: new Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green[700], Colors.green[800], Colors.green[900]]
            ),

          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(90, 30, 90, 0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  
                  backgroundImage: NetworkImage(imageURL),
                  radius: 60,
                ),
              ),
              Text(
                name, 
                textAlign: TextAlign.center, 
                style: TextStyle(
                  height: 1.8,
                  fontSize: 20,
                  color: Colors.grey[300],
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        )
      ),
      body: _map()
    );
  }

  Widget _map(){
    if (_position == null) {
      return null;
    }
    return GoogleMap(
          myLocationButtonEnabled: true,
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


