import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
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
          'BikeTrilhas utiliza o serviço de GPS para acompanhar em tempo real a geolocalização do usuário com o objetivo de ajudar na localização das partes das trilhas, facilitando a compreensão.\nOs dados de geolocalização só serão armazenados caso o usuário crie um novo waypoint ou uma nova trilha, ciclovia e cicloturismo',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Ativar Permissão',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Para gerir as permissões, abra\nconfigurações do app -> permissões -> localização\nOu então, clique no botão abaixo',
          style: TextStyle(fontSize: 16),
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
                Image(
                    image: AssetImage("images/google_logo.png"), height: 35.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('Permission options',
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
