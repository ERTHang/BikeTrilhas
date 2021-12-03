import 'dart:io';

import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class DisplayPage extends StatefulWidget {
  final String title;
  final String path;
  const DisplayPage({Key key, this.title = "Display", this.path})
      : super(key: key);

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  final TextEditingController nameController = TextEditingController();

  savePicture() async {
    String imagePath = widget.path;

    final path = join(
      (await getApplicationDocumentsDirectory()).path,
      '${DateTime.now()}.png',
    );
    File(imagePath).copy(path);

    MapController mapController = Modular.get();
    mapController.modelWaypoint =
        DadosWaypointModel(nome: nameController.text, numImagens: 1);

    mapController.modelWaypoint.imagens.add(path);

    var pos = await Geolocator.getCurrentPosition();
    mapController.newWaypoint =
        WaypointModel(posicao: LatLng(pos.latitude, pos.longitude));

    // if (await isOnline()) {
    Modular.to
        .pushReplacementNamed('/map/editorwaypoint', arguments: EditMode.ADD);
    // } else {
    //   mapController.followTrail =
    //       TrilhaModel(mapController.nextCodt(), 'MarkerOnly');
    //   mapController.createdTrails.add(mapController.followTrail);
    //   mapController.createdTrails.last.waypoints.add(mapController.newWaypoint);
    //   mapController.trilhaRepository
    //       .saveRecordedTrail(mapController.followTrail)
    //       .then((value) {
    //     Modular.to.pushReplacementNamed('/usertrail');
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: savePicture,
        backgroundColor: Colors.blue,
        child: Icon(Icons.send),
      ),
      body: Stack(
        children: <Widget>[
          PhotoView(
            imageProvider: FileImage(File(widget.path), scale: 1),
            minScale: PhotoViewComputedScale.contained,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Color.fromARGB(80, 80, 80, 80),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: TextField(
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.sentences,
                  controller: nameController,
                  cursorRadius: Radius.circular(200),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nome do Waypoint',
                      hintStyle: TextStyle(color: Colors.white70)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
