import 'package:biketrilhas_modular/app/shared/storage/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'info_controller.dart';

class InfoPage extends StatefulWidget {
  final String title;
  const InfoPage({Key key, this.title = "Nemobis"}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends ModularState<InfoPage, InfoController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Center(
              child: Column(children: [
            Text(
              'NEMOBIS - NÚCLEO DE ESTUDOS SOBRE MOBILIDADE SUSTENTÁVEL',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'NEMOBIS é um programa de extensão da UDESC - CCT coordenado pelo prof. Fabiano Baldo ' +
                  'em que tem por objetivo a promoção de ações que visam incentivar o uso de modos sustentáveis' +
                  ' de transporte no município de Joinville.',
              style: TextStyle(fontSize: 16),
            ),
          ])),
        ));
  }
}
