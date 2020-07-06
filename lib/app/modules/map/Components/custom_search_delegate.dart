import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<TrilhaModel> {

  final MapController mapController;

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
    var trilhas = mapController.trilhas.value;
    if (mapController.typeFilter.isNotEmpty) {
      trilhas = trilhas.where((element) => mapController.typeFilter.contains(element.codt)).toList();
    }
    final List<TrilhaModel> list = query.isEmpty
        ? trilhas
        : trilhas.where((p) => p.nome.toLowerCase().startsWith(query));

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.directions_bike),
          title: Text(list[index].nome),
          onTap: () {
            close(context, list[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var trilhas = mapController.trilhas.value;
    if (mapController.typeFilter.isNotEmpty) {
      trilhas = trilhas.where((element) => mapController.typeFilter.contains(element.codt)).toList();
    }
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
            close(context, trilhalist.elementAt(index));
          },
        );
      },
    );
  }
}
