import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:biketrilhas_modular/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

class PermissionPage extends StatefulWidget {
  final String title;
  const PermissionPage({Key key, this.title = "Permission"}) : super(key: key);

  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    disposer = autorun((_) async {});
  }

  @override
  void dispose() {
    super.dispose();
    disposer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Permissão',
          style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
          child: Column(children: [
        Text(
          'Condições de Permissão',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'BikeTrilhas utiliza o serviço de localização para acompanhar em tempo real a geolocalização do usuário com o objetivo de localiza-lo na trilha.',
          //s, facilitando a compreensão.\nOs dados de geolocalização só serão armazenados caso o usuário crie um novo waypoint ou uma nova trilha, ciclovia e cicloturismo
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 30,
        ),
        OutlineButton(
          splashColor: Colors.grey,
          onPressed: () async {
            LocationPermission _permissionGranted =
                await Geolocator.requestPermission();
            if (_permissionGranted != LocationPermission.denied) {
              functionPermisionEnables(context);
            } else {
              return;
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('Ativar Permissão',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
        ),
      ])),
    );
  }
}
