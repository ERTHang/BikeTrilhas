import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DrawerPage extends StatefulWidget {
  final String title;
  const DrawerPage({Key key, this.title = "Drawer"}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final auth = Modular.get<AuthController>();

  final draw = Modular.get<DrawerClassController>();

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
            padding: const EdgeInsets.fromLTRB(90, 30, 90, 0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(auth.user.photoUrl),
              radius: 60,
            ),
          ),
          Text(
            auth.user.displayName.toLowerCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.8,
                fontSize: 25,
                color: Colors.grey[300],
                fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.black,
              size: 40,
            ),
            title: Observer(builder: (_) {
              Color cor;
              cor = (draw.value == 0) ? Colors.white : Colors.black;
              return Text(
                'Mapa',
                style: TextStyle(
                    height: 1.8,
                    fontSize: 18,
                    color: cor,
                    fontWeight: FontWeight.bold),
              );
            }),
            dense: true,
            onTap: () {
              if (draw.value != 0) {
                draw.value = 0;
                Modular.to.popUntil(ModalRoute.withName('/map'));
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: Colors.black,
              size: 40,
            ),
            title: Observer(builder: (_) {
              Color cor;
              cor = (draw.value == 1) ? Colors.white : Colors.black;
              return Text(
                'Filtros',
                style: TextStyle(
                    height: 1.8,
                    fontSize: 18,
                    color: cor,
                    fontWeight: FontWeight.bold),
              );
            }),
            dense: true,
            onTap: () {
              if (draw.value != 1) {
                draw.value = 1;
                Modular.to.pushNamed('/filter');
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.directions_bike,
              color: Colors.black,
              size: 40,
            ),
            title: Observer(builder: (_) {
              Color cor;
              cor = (draw.value == 2) ? Colors.white : Colors.black;
              return Text(
                'Suas rotas',
                style: TextStyle(
                    height: 1.8,
                    fontSize: 18,
                    color: cor,
                    fontWeight: FontWeight.bold),
              );
            }),
            dense: true,
            onTap: () {
              draw.value = 2;
              Modular.to.pushNamed("/usertrail");
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.place,
          //     color: Colors.black,
          //     size: 40,
          //   ),
          //   title: Observer(builder: (_) {
          //     Color cor;
          //     cor = (draw.value == 3) ? Colors.white : Colors.black;
          //     return Text(
          //       'Sinalizações',
          //       style: TextStyle(
          //           height: 1.8,
          //           fontSize: 18,
          //           color: cor,
          //           fontWeight: FontWeight.bold),
          //     );
          //   }),
          //   dense: true,
          //   onTap: () {
          //     draw.value = 3;
          //     Modular.to.pushNamed("/waypoint");
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     Icons.timeline,
          //     color: Colors.black,
          //     size: 40,
          //   ),
          //   title: Observer(builder: (_) {
          //     Color cor;
          //     cor = (draw.value == 4) ? Colors.white : Colors.black;
          //     return Text(
          //       'Indicadores',
          //       style: TextStyle(
          //           height: 1.8,
          //           fontSize: 18,
          //           color: cor,
          //           fontWeight: FontWeight.bold),
          //     );
          //   }),
          //   dense: true,
          //   onTap: () {
          //     draw.value = 4;
              // final snackBar = SnackBar(content: Text("Não implementado"));
              // Scaffold.of(context).removeCurrentSnackBar();
              // Scaffold.of(context).showSnackBar(snackBar);
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     Icons.portable_wifi_off,
          //     color: Colors.black,
          //     size: 40,
          //   ),
          //   title: Observer(builder: (_) {
          //     Color cor;
          //     cor = (draw.value == 5) ? Colors.white : Colors.black;
          //     return Text(
          //       'Modo Offline',
          //       style: TextStyle(
          //           height: 1.8,
          //           fontSize: 18,
          //           color: cor,
          //           fontWeight: FontWeight.bold),
          //     );
          //   }),
          //   dense: true,
          //   onTap: () {
          //     draw.value = 5;
          //     final snackBar = SnackBar(content: Text("Não implementado"));
          //     Scaffold.of(context).removeCurrentSnackBar();
          //     Scaffold.of(context).showSnackBar(snackBar);
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.black,
              size: 40,
            ),
            title: Observer(builder: (_) {
              Color cor;
              cor = (draw.value == 6) ? Colors.white : Colors.black;
              return Text(
                'Sobre',
                style: TextStyle(
                    height: 1.8,
                    fontSize: 18,
                    color: cor,
                    fontWeight: FontWeight.bold),
              );
            }),
            dense: true,
            onTap: () {
              if (draw.value != 6) {
                draw.value = 6;
                Modular.to.pushNamed('/info');
              }
            },
          ),
        ],
      ),
    ));
  }
}
