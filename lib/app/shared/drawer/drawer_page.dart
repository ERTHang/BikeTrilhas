import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
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
                if (await isOnline() == true) {
                  Navigator.pop(context);
                  Modular.to.pushNamed('/filter');
                } else {
                  alert(context, 'Filtro indisponivel offline');
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
              if (draw.value != 2) {
                draw.value = 2;
                Navigator.pop(context);
                Modular.to.pushNamed("/userroute");
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
}
