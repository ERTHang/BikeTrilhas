import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'search_controller.dart';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key key, this.title = "Search"}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ModularState<SearchPage, SearchController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Trilhas'),
        centerTitle: true,
      ),
      drawer: Scaffold(
        backgroundColor: Colors.transparent,
        body: DrawerPage(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Post>(
            onSearch: search,
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(post.title),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<Post>> search(String search) async {
    final snackBar = SnackBar(content: Text("Servidor não encontrado"));
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
    List lista;
    await Future.delayed(Duration(seconds: 2));
    Post post = Post("Banco não encontrado");
    lista.add(post);
    return lista;
  }
}

class Post {
  final String title;

  Post(this.title);
}
