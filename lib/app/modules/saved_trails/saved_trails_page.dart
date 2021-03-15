import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:flutter/material.dart';

class SavedTrailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trilhas Salvas',
          style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    List<DadosTrilhaModel> lista = dadosTrilhasModel;

    if (lista.length == 0) {
      return Center(
        child: Container(
          child: Text('Não há trilhas salvas!'),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: lista != null ? lista.length : 0,
          itemBuilder: (context, index) {
            DadosTrilhaModel c = lista[index];

            return Card(
              color: Colors.grey[200],
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Codigo: ${c.codt},'),
                      SizedBox(height: 5),
                      Text('Nome: ${c.nome}'),
                      SizedBox(height: 5),
                      Text('Comprimento: ${c.comprimento}'),
                      SizedBox(height: 5),
                      Text('Desnivel: ${c.desnivel}'),
                      SizedBox(height: 5),
                      Text('tipo: ${c.tipo}'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
