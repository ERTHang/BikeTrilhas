import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

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
              backgroundImage: NetworkImage(auth.user.photoURL),
              radius: 60,
            ),
          ),
          Text(
            toCamelCase(auth.user.displayName),
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
              draw.value = 0;
              Navigator.pop(context);
              Modular.to.popUntil((route) => route.isFirst);
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
            onTap: () async {
              if (draw.value != 1) {
                if (await isOnline() && await permissao()) {
                  Navigator.pop(context);
                  Modular.to.pushNamed('/filter');
                } else {
                  Navigator.pop(context);
                  snackAlert(context, 'Filtro indisponível');
                }
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
                'Rotas',
                style: TextStyle(
                    height: 1.8,
                    fontSize: 18,
                    color: cor,
                    fontWeight: FontWeight.bold),
              );
            }),
            dense: true,
            onTap: () async {
              if (await permissao()) {
                if (draw.value != 2) {
                  Navigator.pop(context);
                  Modular.to.pushNamed("/userroute");
                }
              } else {
                Navigator.pop(context);
                snackAlert(context, 'Rotas indisponíveis');
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.track_changes_rounded,
              color: Colors.black,
              size: 40,
            ),
            title: Observer(builder: (_) {
              Color cor;
              cor = (draw.value == 10) ? Colors.white : Colors.black;
              return Text(
                'Trilhas',
                style: TextStyle(
                    height: 1.8,
                    fontSize: 18,
                    color: cor,
                    fontWeight: FontWeight.bold),
              );
            }),
            dense: true,
            onTap: () async {
              if (await permissao()) {
                if (draw.value != 10) {
                  Navigator.pop(context);
                  Modular.to.pushNamed("/usertrail");
                }
              } else {
                Navigator.pop(context);
                snackAlert(context, 'Trilhas indisponíveis');
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.app_settings_alt_rounded,
              color: Colors.black,
              size: 40,
            ),
            title: Observer(builder: (_) {
              Color cor;
              cor = (draw.value == 10) ? Colors.white : Colors.black;
              return Text(
                'Configurações',
                style: TextStyle(
                    height: 1.8,
                    fontSize: 18,
                    color: cor,
                    fontWeight: FontWeight.bold),
              );
            }),
            dense: true,
            onTap: () {
              if (draw.value != 10) {
                Navigator.pop(context);
                Modular.to.pushNamed("/permission");
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.black,
              size: 40,
            ),
            title: Observer(builder: (_) {
              Color cor;
              cor = (draw.value == 3) ? Colors.white : Colors.black;
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
              if (draw.value != 3) {
                draw.value = 3;
                Navigator.pop(context);
                Modular.to.pushNamed('/info');
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.launch,
              color: Colors.black,
              size: 40,
            ),
            title: Observer(builder: (_) {
              Color cor;
              cor = (draw.value == 6) ? Colors.white : Colors.black;
              return Text(
                'Política de Privacidade',
                style: TextStyle(
                    height: 1.8,
                    fontSize: 18,
                    color: cor,
                    fontWeight: FontWeight.bold),
              );
            }),
            dense: true,
            onTap: () async {
              Navigator.pop(context);
              if (await canLaunch(
                  'https://bdes.joinville.udesc.br/politica/Politica_de_privacidade-Bike_Trilhas.pdf')) {
                await launch(
                    'https://bdes.joinville.udesc.br/politica/Politica_de_privacidade-Bike_Trilhas.pdf');
              }
            },
          ),
        ],
      ),
    ));
  }

  String toCamelCase(String str) {
    String s = str
        .replaceAllMapped(
            RegExp(
                r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
            (Match m) =>
                "${m[0][0].toUpperCase()}${m[0].substring(1).toLowerCase()}")
        .replaceAll(RegExp(r'(_|-|\s)+'), ' ');
    return s[0].toUpperCase() + s.substring(1);
  }
}
