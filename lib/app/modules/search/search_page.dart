import 'dart:async';

import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'search_controller.dart';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key key, this.title = "Search"}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ModularState<SearchPage, SearchController> {
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Trilhas'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                getPolyResult();
              })
        ],
      ),
      drawer: Scaffold(
        backgroundColor: Colors.transparent,
        body: DrawerPage(),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        polylines: polylines,
        mapType: MapType.normal,
        initialCameraPosition: controller.mapController.position.value,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  getPolyResult() async {
    final trilha = await showSearch(
        context: context, delegate: CustomSearchDelegate(controller));

    if (trilha == null) {
      return;
    }
    setState(
      () {
        polylines.add(
          Polyline(
            polylineId: PolylineId(trilha.nome),
            color: Colors.red,
            points: trilha.polylineCoordinates,
            width: 3,
          ),
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<TrilhaModel> {
  CustomSearchDelegate(this.controller);

  final SearchController controller;

  final List<TrilhaModel> recentSearch = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final trilhas = controller.mapController.trilhas.value;
    final List<TrilhaModel> list = query.isEmpty
        ? recentSearch
        : trilhas.where((p) => p.nome.toLowerCase().startsWith(query));

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.directions_bike),
          title: Text(list[index].nome),
          onTap: () {
            recentSearch.add(list[index]);
            close(context, list[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final trilhas = controller.mapController.trilhas.value;
    final trilhalist = query.isEmpty
        ? recentSearch
        : trilhas.where((p) => p.nome.toLowerCase().startsWith(query));

    return ListView.builder(
      itemCount: trilhalist.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.directions_bike),
          title: Text(trilhalist.elementAt(index).nome),
          onTap: () {
            recentSearch.add(trilhalist.elementAt(index));
            close(context, trilhalist.elementAt(index));
          },
        );
      },
    );
  }
}
