import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<TrilhaModel> {

  final MapController mapController;

  final List<TrilhaModel> recentSearch = [];

  CustomSearchDelegate(this.mapController);

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
    final trilhas = mapController.trilhas.value;
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
    final trilhas = mapController.trilhas.value;
    final trilhalist = query.isEmpty
        ? trilhas
        : trilhas.where((p) => p.nome.toLowerCase().startsWith(query.toLowerCase()));

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
