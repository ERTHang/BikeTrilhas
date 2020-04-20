import 'package:flutter/material.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DrawerClass extends StatelessWidget {

  final auth = Modular.get<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[300], Colors.blue[400], Colors.blue]),
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(75, 30, 75, 0),
            child: CircleAvatar(
              
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(auth.user.photoUrl),
              radius: 75,
            ),
          ),
          Text(
            auth.user.displayName.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.5,
                fontSize: 45,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.black,
              size: 50,
            ),
            title: Text(
              'Mapa',
              style: TextStyle(
                  height: 2.5,
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            dense: true,
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: Colors.black,
              size: 50,
            ),
            title: Text(
              'Buscar Trilhas',
              style: TextStyle(
                  height: 2.5,
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            dense: true,
          ),
          ListTile(
            leading: Icon(
              Icons.directions_bike,
              color: Colors.black,
              size: 50,
            ),
            title: Text(
              'Suas Trilhas',
              style: TextStyle(
                  height: 2.5,
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            dense: true,
          ),
          ListTile(
            leading: Icon(
              Icons.place,
              color: Colors.black,
              size: 50,
            ),
            title: Text(
              'Sinalizações',
              style: TextStyle(
                  height: 2.5,
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            dense: true,
          ),
          ListTile(
            leading: Icon(
              Icons.timeline,
              color: Colors.black,
              size: 50,
            ),
            title: Text(
              'Indicadores',
              style: TextStyle(
                  height: 2.5,
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            dense: true,
          ),
          ListTile(
            leading: Icon(
              Icons.portable_wifi_off,
              color: Colors.black,
              size: 50,
            ),
            title: Text(
              'Modo Offline',
              style: TextStyle(
                  height: 2.5,
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            dense: true,
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.black,
              size: 50,
            ),
            title: Text(
              'Sobre',
              style: TextStyle(
                  height: 2.5,
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            dense: true,
          ),
        ],
      ),
    ));
  }
}
