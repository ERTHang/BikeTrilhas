import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:flutter/material.dart';

class MarkerPage extends StatefulWidget {
  final String title;
  final TrilhaModel trilha;
  const MarkerPage({Key key, this.title = "Marker", this.trilha}) : super(key: key);

  @override
  _MarkerPageState createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trilha.nome),
        centerTitle: true,
      ),
      drawer: DrawerPage(),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
